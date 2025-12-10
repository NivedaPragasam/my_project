/* Member: ORCHESTRATOR in APP/QCLSRC, Type: CLLE */
             PGM        PARM(&CUST &ENV)
 
             /* ===========================
                Declarations
               =========================== */
             DCL        VAR(&CUST)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENV)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTL_LIB)  TYPE(*CHAR) LEN(10) VALUE('APPCTL')
             DCL        VAR(&MSGQ)     TYPE(*CHAR) LEN(20) VALUE('ORCHMSGQ')
             DCL        VAR(&FULLMSGQ) TYPE(*CHAR) LEN(21) /* LIB/OBJ */
 
             DCL        VAR(&MSGID)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGTXT)   TYPE(*CHAR) LEN(512)
             DCL        VAR(&MSGDTA)   TYPE(*CHAR) LEN(512)
 
             DCL        VAR(&JOBS_DONE) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&TIMEOUT)   TYPE(*DEC) LEN(5 0) VALUE(600) /* seconds */
             DCL        VAR(&ELAPSED)   TYPE(*DEC) LEN(5 0) VALUE(0)
 
             DCL        VAR(&JOBINF)   TYPE(*CHAR) LEN(26) /* '123456/USER/JOBNAME' */
             DCL        VAR(&JOBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR)   TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&SQLCMD)   TYPE(*CHAR) LEN(500)
             DCL        VAR(&CURDATE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURTIME)  TYPE(*CHAR) LEN(8)
 
             /* ===========================
                Environment setup
               =========================== */
             /* Ensure consistent CCSID / decimal format, etc. */
             CHGJOB     CCSID(500) DFTWAIT(30)
 
             /* Set library list based on ENV (e.g., DEV/TEST/PROD) */
             MONMSG     MSGID(CPF0000)
             CHGLIBL    LIBL(QSYS QGPL QTEMP APP APPGEN &CTL_LIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Failed to set LIBL')
               RETURN
             ENDDO
 
             /* ===========================
                Prepare control message queue
               =========================== */
             /* Build fully-qualified message queue name */
             CHGVAR     VAR(&FULLMSGQ) VALUE(&CTL_LIB *TCAT '/' *TCAT &MSGQ)
 
             /* Create message queue if not present */
             CRTMSGQ    MSGQ(&FULLMSGQ) TEXT('Orchestrator control queue')
             MONMSG     MSGID(CPF2105) /* Object exists, continue */
 
             /* Clear any old messages */
             CLRMSGQ    MSGQ(&FULLMSGQ)
             MONMSG     MSGID(CPF0000)
 
             /* ===========================
                Start commitment control
               =========================== */
             STRCMTCTL  LCKLVL(*ALL) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Failed to start commitment control')
               RETURN
             ENDDO
 
             /* ===========================
                Setup overrides / session log
               =========================== */
             /* Example: Override a file to a specific member with sharing */
             OVRDBF     FILE(INORDERS) TOFILE(APPDATA/ORDERS) MBR(*FIRST) +
                         SHARE(*YES)
             MONMSG     MSGID(CPF0000)
 
             /* Create a QTEMP session log table via RUNSQL */
             CHGVAR     VAR(&SQLCMD) VALUE(
                          'CREATE TABLE QTEMP.SESSION_LOG(' *TCAT +
                          ' TS TIMESTAMP NOT NULL,' *TCAT +
                          ' PHASE CHAR(20) NOT NULL,' *TCAT +
                          ' DETAIL VARCHAR(200))')
             RUNSQL     SQL(&SQLCMD) NAMING(*SYS) COMMIT(*NONE)
             MONMSG     MSGID(CPF0000)
 
             /* Log phase: INIT */
             RUNSQL     SQL('INSERT INTO QTEMP.SESSION_LOG ' *TCAT +
                         'VALUES(CURRENT_TIMESTAMP, ''INIT'', ''Start'')') +
                         COMMIT(*NONE)
 
             /* ===========================
                Call initial program (serial)
               =========================== */
             CALL       PGM(APP/INITPGM) PARM(&CUST &ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Error in INITPGM; rolled back.')
               RETURN
             ENDDO
 
             /* Example: call ILE procedure in a service program */
             /* Assumes TAXSRV is bound/exported and found via LIBL/bind dir */
             DCL        VAR(&AMT) TYPE(*DEC) LEN(9 2) VALUE(100.00)
             CALLPRC    PRC('TAXCALC') PARM(&AMT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               /* Not critical; continue with warning */
               SNDPGMMSG  MSG('Warning: TAXCALC procedure failed.') TOPGMQ(*EXT)
             ENDDO
 
             /* ===========================
                Submit two parallel jobs
               =========================== */
 
             /* Job A */
             SBMJOB     CMD(CALL PGM(APP/WORKA) PARM(&CUST &ENV)) +
                        JOB(WORKA) JOBQ(APP/QBATCH) +
                        MSGQ(&FULLMSGQ) /* route job messages to control queue */
             MONMSG     MSGID(CPF0000) EXEC(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Failed to submit WORKA')
               RETURN
             ENDDO
 
             /* Job B */
             SBMJOB     CMD(CALL PGM(APP/WORKB) PARM(&CUST &ENV)) +
                        JOB(WORKB) JOBQ(APP/QBATCH) +
                        MSGQ(&FULLMSGQ)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Failed to submit WORKB')
               RETURN
             ENDDO
 
             /* ===========================
                Wait for both jobs to end (CPF1164)
               =========================== */
             DOUNTIL    COND(&JOBS_DONE *EQ 2 *OR &ELAPSED *GE &TIMEOUT)
               /* Wait up to 10s for a message from either job */
               RCVMSG     MSGQ(&FULLMSGQ) MSGTYPE(*ANY) WAIT(10) RMV(*YES) +
                          MSGID(&MSGID) MSGDTA(&MSGDTA) MSG(&MSGTXT)
               MONMSG     MSGID(CPF0000) /* No message; proceed */
 
               IF         COND(&MSGID *EQ 'CPF1164') THEN(DO)
                 /* Job ended; parse message data for job id/user/name */
                 /* MSGDTA contains 'job 123456/user/jobname ended ...' but
                    safer to use &JOBINF from message where supported.
                    If not, parse substrings. Example below uses string ops. */
                 /* Example: Some formats deliver job info in first 26 chars */
                 CHGVAR     VAR(&JOBINF) VALUE(%SST(&MSGDTA 1 26))
                 CHGVAR     VAR(&JOBNBR) VALUE(%SST(&JOBINF 1 6))
                 CHGVAR     VAR(&USER)   VALUE(%SST(&JOBINF 8 10))
                 CHGVAR     VAR(&JOBNAME) VALUE(%SST(&JOBINF 19 8))
 
                 CHGVAR     VAR(&JOBS_DONE) VALUE(&JOBS_DONE + 1)
 
                 RUNSQL     SQL('INSERT INTO QTEMP.SESSION_LOG ' *TCAT +
                             'VALUES(CURRENT_TIMESTAMP, ''JOB_END'', ' *TCAT +
                             '''' *TCAT &JOBNAME *TCAT ''')') COMMIT(*NONE)
               ENDDO
 
               /* Increment elapsed time */
               CHGVAR     VAR(&ELAPSED) VALUE(&ELAPSED + 10)
             ENDDO
 
             IF         COND(&JOBS_DONE *LT 2) THEN(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Timeout waiting for parallel jobs.')
               RETURN
             ENDDO
 
             /* ===========================
                Finalization: post-processing & commit
               =========================== */
 
             /* Run a post step program to consolidate results */
             CALL       PGM(APP/POSTSTEP) PARM(&CUST)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                           MSGDTA('Error in POSTSTEP; rolled back.')
               RETURN
             ENDDO
 
             
            ADDJOBSCDE JOB(MIDNIGHT) CMD(CALL PGM(APP/MIDNIGHTRUN)) +
                    FRQ(*DAILY) SCDDATE(*NONE) SCDTIME('00:00:00') +
                    JOBD(APP/SCHEDJOBD) TEXT('Nightly process')
 
 
             /* Log phase: DONE */
             RUNSQL     SQL('INSERT INTO QTEMP.SESSION_LOG ' *TCAT +
                         'VALUES(CURRENT_TIMESTAMP, ''DONE'', ''Success'')') +
                         COMMIT(*NONE)
 
             /* Commit transactional changes */
             COMMIT
 
             /* Cleanup overrides */
             DLTF       FILE(QTEMP/SESSION_LOG)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(INORDERS)
             MONMSG     MSGID(CPF0000)
 
             ENDPGM