      ******************************************************************
      *  opensource COBOL and AWS Lambda sample program
      ******************************************************************
       IDENTIFICATION              DIVISION.
      ******************************************************************
       PROGRAM-ID.                 aws_cobol.
       AUTHOR.                     kazuOji.
       DATE-WRITTEN.               2020-03-11.
      ******************************************************************
       ENVIRONMENT                 DIVISION.
      ******************************************************************
       INPUT-OUTPUT                SECTION.
       FILE-CONTROL.
           SELECT  INVITEE-LIST    ASSIGN  TO  "INVITEE_LIST.csv".
      ******************************************************************
       DATA                        DIVISION.
      ******************************************************************
       FILE                        SECTION.
       FD  INVITEE-LIST
           LABEL   RECORD      IS  STANDARD
           BLOCK   CONTAINS    0   RECORDS.
       01  INVITEE-LIST-REC            PIC X(29)
      ******************************************************************
       WORKING-STORAGE             SECTION.
       01  RETURN-STR               PIC  X(256).
       01  INPUT-DATA
           03  NON-STR-1               PIC  X(9).
           03  INP-FNAME               PIC  X(10).
           03  INP-LNAME               PIC  X(10).
           03  INP-BYEAR               PIC  9(4).
           03  INP-BMONTH              PIC  Z9.
           03  INP-BDAY                PIC  Z9.
           03  NON-STR-2               PIC  X(2).
       01  LIST-DATA
           03  LST-FNAME               PIC  X(10).
           03  LST-LNAME               PIC  X(10).
           03  LST-BYEAR               PIC  9(4).
           03  LST-BMONTH              PIC  Z9.
           03  LST-BDAY                PIC  Z9.
       01  SPACE-IDX                   PIC  9(005).
       01  SW-END                      PIC 9(01)   VALUE   ZERO.
       01  CNS-ON                      PIC 9(01)   VALUE   1.
       01  MATCH-FLAG                  PIC 9(01)   VALUE   ZERO.
       01  MATCH-CD                    PIC 9(01)   VALUE   1.
       01  CNT-FNAME                   PIC 9(02)   VALUE   ZERO.
       01  CNT-LNAME                   PIC 9(02)   VALUE   ZERO.
      ******************************************************************
       PROCEDURE                   DIVISION.
      ******************************************************************
       MAIN-RTN.
           STRING  '{"statusCode": 200, '         DELIMITED BY SIZE
                   '"body": "Hello Kengorian from opensource COBOL!", '
                                                  DELIMITED BY SIZE
                   '"input": {;'                  DELIMITED BY SIZE
                   INTO RETURN-STR.

       ACCEPT-INPUT.
           ACCEPT  INPUT-DATA FROM CONSOLE.

       CNT-LENGTH.
           INSPECT INP-FNAME TALLYING CNT-FNAME
                                            FOR CHARACTERS BEFORE "-".
           INSPECT INP-LNAME TALLYING CNT-LNAME
                                            FOR CHARACTERS BEFORE "-".

       READ-FILE-INIT.
           OPEN    INPUT          INVITEE-LIST.
           READ    INVITEE-LIST   INTO    LIST-DATA
               AT END  MOVE    CNS-ON  TO  SW-END.
       MATCHING.
           PERFORM UNTIL (SW-END = CNS-ON OR MATCH-FLAG = 1)
               IF  INP-FNAME ( 1 : CNT-FNAME ) = LST-FNAME AND
                   INP-LNAME ( 1 : CNT-LNAME ) = LST-LNAME AND
                   INP-BYEAR = LST-BYEAR AND
                   INP-BMONTH = LST-BMONTH AND
                   INP-BDAY = LST-BDAY
                   MOVE MATCH-CD TO MATCH-FLAG
               END-IF  
                   
               READ    INVITEE-LIST   INTO    LIST-DATA
                   AT END  MOVE    CNS-ON  TO  SW-END
               END-READ
           END-PERFORM.

       RETURN-SMMRY.
           IF  MATCH-FLAG = 1
               STRING  RETURN-STR                  DELIMITED BY ";"
                       '"FIRST_NAME":"'            DELIMITED BY SIZE
                       INP-FNAME ( 1 : CNT-FNAME ) DELIMITED BY SIZE
                       '","LAST_NAME":"'           DELIMITED BY SIZE
                       INP-LNAME ( 1 : CNT-LNAME ) DELIMITED BY SIZE
                       '","BIRTH_YEAR":"'          DELIMITED BY SIZE
                       INP-BYEAR                   DELIMITED BY SIZE
                       '","BIRTH_MONTH":"'         DELIMITED BY SIZE
                       INP-BMONTH                  DELIMITED BY SIZE
                       '","BIRTH_DAY":"'           DELIMITED BY SIZE
                       INP-BDAY                    DELIMITED BY SIZE
                       '"},"return_code": 0}'      DELIMITED BY SIZE
                       INTO RETURN-STR
           ELSE
               STRING  RETURN-STR                  DELIMITED BY ";"
                       '"FIRST_NAME":"'            DELIMITED BY SIZE
                       INP-FNAME ( 1 : CNT-FNAME ) DELIMITED BY SIZE
                       '","LAST_NAME":"'           DELIMITED BY SIZE
                       INP-LNAME ( 1 : CNT-LNAME ) DELIMITED BY SIZE
                       '","BIRTH_YEAR":"'          DELIMITED BY SIZE
                       INP-BYEAR                   DELIMITED BY SIZE
                       '","BIRTH_MONTH":"'         DELIMITED BY SIZE
                       INP-BMONTH                  DELIMITED BY SIZE
                       '","BIRTH_DAY":"'           DELIMITED BY SIZE
                       INP-BDAY                    DELIMITED BY SIZE
                       '"},"return_code": -1}'     DELIMITED BY SIZE
                       INTO RETURN-STR
           END-IF.


       MATCH-EXIT.
           DISPLAY RETURN-STR.
           CLOSE   INVITEE-LIST.
           STOP RUN.

