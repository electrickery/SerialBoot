

    
    org     03F00h    
    defb    '***************************'
    org     03F40h    
    defb    '**  testing serial boot  **'
    org     03F80h   
    defb    '***************************'

    org     06000h
    
    LD      BC, 3C00h
loop:
    LD      A, (03820h)
    BIT     6, A 
    JP      NZ, NEXTPG
    BIT     4, A
    JP      NZ, PREVPG
    JP      loop 
        
NEXTPG:
    LD      A, '+'
    LD      (BC), A
    JP      NXTLOC
    
PREVPG:
    LD      A, '-'
    LD      (BC), A
    JP      NXTLOC
    
NXTLOC:
    INC     BC
    LD      A, C
    CP      0
    JR      NZ, not0
    LD      BC, 3C00h
not0:
    jp  loop
    
    
    end
