// N ( Numerator ) as R0 ( RAM [0])
// D ( Denominator ) as R1 ( RAM [1])
// Q ( Quotient ) as R2 ( RAM [2])
// R ( Rest ) as R3 ( RAM [3])

// Inicializando Flags
@4
M=0
@5
M=0

// Verifica se Denominador = 0:
@R1
D=M
@DZERO
D;JEQ

// Verifica se denominador é negativo:
@R1
D=M
@DNEG
D;JLT

(RET)
// Verifica se numerador é negativo:
@R0
D=M
@NumNEG
D;JLT

(DIVISAO)
  @R2
  M=0
  @R0
  D=M
  @R3
  M=D
  @R1
  D=D-M
  @JumpEND
  D;JLT
  (LOOP)
    @R2
    M=M+1
    @R1
    D=M
    @R3
    M=M-D
    D=M-D
    @LOOP
    D;JGE

@JumpEND
0;JMP

// If D = 0, then:
(DZERO)
  @R2
  M=D
  @32767
  D=A
  @R3
  M=D
  @END
  0;JMP

// If D < 0, then divide(N,-D)
(DNEG)
  @R1
  D=!M
  M=D+1
  @4            // flag para D < 0
  M=M+1
  @RET
  0;JMP

// If N < 0, then divide(-N,D)
(NumNEG)
  @R0
  D=!M
  M=D+1
  @5            // flag para N < 0
  M=M+1
  @DIVISAO
  0;JMP

(JumpEND)
  // N < 0 -> flag != 0
  @5
  D=M
  @CONT
  D;JEQ         // verifica se flag para N < 0 ainda continua 0
  @0            // se não, volta o sinal do numerador para negativo
  D=!M
  M=D+1
  @3
  D=M
  @RZERO        // verifica se resto = 0
  D;JEQ         // se sim, salta
  @R2           // se não, return(-Q-1,D-R)
  D=!M
  M=D

  (CONT)
  // D < 0 -> flag != 0
  @4
  D=M
  @END
  D;JEQ         // verifica se flag para D < 0 ainda continua 0
  @R1           // se não, volta o sinal do denominador para negativo
  D=!M
  M=D+1
  @R2           // return(-Q,R)
  D=!M
  M=D+1
  
  @END
  0;JMP

  (RZERO)      // se resto = 0, return(-Q,0)
    @R2
    D=!M
    M=D+1

(END)
  @4
  M=0
  @5
  M=0
  (INFINITY)
  @INFINITY
  0;JMP