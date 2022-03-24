

    
    org     03F00h    
    defb    '***************************'
    org     03F40h    
    defb    '**  testing serial boot  **'
    org     03F80h   
    defb    '***************************'

    org     06000h
loop:
    jp  loop
    
    
    end
