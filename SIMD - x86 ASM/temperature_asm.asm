global temperature_asm
section .rodata

    tres_fp: dq 3.0
    sacar_a: times 2 dq 0x0000000000ffffff 
    shuf_para_rgb: db 0x00, 0x80, 0x01, 0x80, 0x02, 0x80, 0x80, 0x80, 0x80, 0x80, 0x08, 0x80, 0x09, 0x80, 0xa, 0x80 
    ;xmm0 = [0,0,0,0,0,r,g,b,0,0,0,0,0,r,g,b]
    ;[0x000r, 0x000g, 0x000b, 0x0000, 0x0000, 0x000r, 0x000g, 0x000b]
    mask_para_cvt: db 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;xmm0 = [0, 0, 0, 0, 0, b', 0, a'] (cada digito ocupa un word)
    cuatro: times 4 db 0x04 , 0x00, 0x00, 0x00 ;dd 0x04
    shuffle_caso2: db 0x80, 0x00, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    shuffle_caso3: db 0x80, 0x80, 0x00, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 
    shuffle_caso4: db 0x80, 0x00, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    shuffle_caso5: db 0x80, 0x80, 0x00, 0x80, 0x80, 0x80, 0x04, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 
    num_y_transparencia: db 0x80, 0x00, 0x00, 0xff, 0x80, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    blue_y_transparencia: db 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    red_y_transparencia: db 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    transparencia: db 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    transparencia_y_verde: db 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    caso1: db 0x20, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
    caso2: db 0x60, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
    caso3: db 0xa0, 0x00, 0x00, 0x00, 0xa0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
    caso4: db 0xe0, 0x00, 0x00, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
    caso5: db 0xdf, 0x00, 0x00, 0x00, 0xdf, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
    resta32: db 0x20, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    resta96: db 0x60, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    resta160: db 0xa0, 0x00, 0x00, 0x00, 0xa0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    resta224: db 0xe0, 0x00, 0x00, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    resta_255: db 0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    blend_caso_3: db 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
   
    
section .data

section .text
;void temperature_asm(
;              unsigned char *src[RDI],
;              unsigned char *dst[RSI],
;              int width[RDX],
;              int height[RCX],
;              int src_row_size[R8],
;              int dst_row_size[R9]
;);

temperature_asm:
    push rbp
    push r12 
    push r13
    push r10 ;r10 will store a copy of width
    push r11 ;r11 will store iterator for width_cycle
    mov rbp, rsp
    mov r10, rdx
    
    ;We'll process 2px per cycle iteration
    ;img_width = 8*i so we can process 2px per cycle iteration
    ciclo_altura:
        ;Compares height to 0
        cmp rcx, 0 
        je fin_ciclo_altura
        ;Reset width value
        mov rdx, r10  
        
        ;width_cycle iterator = 0
        xor r11, r11 
        ciclo_ancho:
            ;Compares width to 0
            cmp rdx, 0   
            je fin_ciclo_ancho

            ;----- CALCULATES TEMPERATURE OF 2 PX -----
                ;Loads 2px extended to 0
                PMOVZXDQ xmm0, [rdi + r11] ;xmm0 = [0,0,0,0,a,r,g,b,0,0,0,0,a,r,g,b] 
                ;Loads mask to erase transparency (A in RGBA)
                movdqu xmm1, [sacar_a] 
                ;xmm1 = [0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff]
                
                ;Bitwise AND between Pixels and mask erases transparency
                pand xmm0, xmm1
                
                ;Shuffle xmm0 => xmm0 = [0x000r, 0x000g, 0x000b, 0x0000, 0x0000, 0x000r, 0x000g, 0x000b]
                movdqu xmm1, [shuf_para_rgb]
                pshufb xmm0, xmm1 
                
                ;xmm0 = [r+g, b, r, g+b , repeat]
                phaddsw xmm0, xmm0
                ;xmm0 = [r2+g2+b2, r1+g1+b1, r2+g2+b2, ...] = [b', a', b', ...] (each sum is 1 word) 
                phaddsw xmm0, xmm0   

                ;Shuffles xmm0 to be able to convert RGB sums in DP Floats. First we shuffle then we delete the parts we don't need  
                ;xmm0 = [0, 0, 0, 0, 0, b', 0, a']
                pshuflw xmm0, xmm0, 00010000b 
                movdqu xmm1, [mask_para_cvt]
                pand xmm0, xmm1
                
                ;Converts first 2 doublewords to DP Floats
                ;xmm0 = [b' , a']
                cvtdq2pd xmm0, xmm0
                
                ;Loads 3.0 into xmm1 two times.
                ;xmm1 = [3.0, 3.0]
                movhpd xmm1, [tres_fp]
                movlpd xmm1, [tres_fp]
                
                ;Divides each pixel sum by 3 
                ;xmm0 = [b'/3 , a'/3]
                divpd xmm0, xmm1 
                
                ;Converts both values to double word integers using truncation
                ;xmm0 = [00 .... , 0x00, t2, 0x00, t1]
                cvttpd2dq xmm0, xmm0 
            ;----- CALCULATES TEMPERATURE OF 2 PX -----

            ;We'll store the final result in xmm8
            pxor xmm8, xmm8

            ;Steps for each condition
            ; 1) Load the values of each pixel given that condition into an xmm register
            ; 2) Compare the real values to the condition, that generates a mask
            ; 3) Bitwise AND with the mask and the values we generated on 1), that leaves only the correct values
            ; 4) POR with the correct values and xmm8, that leaves the correct values on xmm8 

            ; -----------------------------------------------
            ; First condition: t < 32 
            ; -----------------------------------------------
                ; 1) xmm9 = [0,0,0,0,0,0,0,0,255,0,0,128 + t2*4,255,0,0,128 + t1*4]
                ;Copy temperatures onto xmm9
                movdqu xmm9, xmm0
                ;xmm10 = [4,4,4,4] (32 bits each)
                movdqu xmm10, [cuatro]
                ;xmm9 = [0,0,t2*4,t1*4] 
                pmulld xmm9, xmm10 
                movdqu xmm10, [num_y_transparencia] 
                paddusb xmm9, xmm10 

                ; 2) Compares temperatures with condition
                ;Copy temperatures onto xmm10
                movdqu xmm10, xmm0 
                ;xmm11 = [0, 0, 32, 32]
                movdqu xmm11, [caso1] 
                pcmpgtd xmm11, xmm10 

                ; 3) PAND leaves only the pixels that meet condition 1
                pand xmm9, xmm11

                ; 4) POR puts the pixels that are != 0 in xmm8 
                por xmm8, xmm9 

            ; 
            
            ;The rest of the conditions follow the same idea. The only difference being that we also use the last mask to also check the last condition.

            ;----------------------------------------------------
            ; Second condition: 32 <= t < 96 
            ; ----------------------------------------------------
                ; 1) xmm9 = [0,0,0,0,0,0,0,0,255,0,(t2 - 32)*4,255,255,0,(t1 - 32)*4,255]
                ;Copy temperatures onto xmm9
                movdqu xmm9, xmm0  
                movdqu xmm10, [resta32]
                psubusb xmm9, xmm10
                movdqu xmm10, [cuatro]
                ;xmm9 = [0,0,(t2-32)*4,(t1-32)*4]
                pmulld xmm9, xmm10 
                movdqu xmm10, [shuffle_caso2]
                ;xmm9 = [0,0,0,0,0,0,0,0,0,0,0,(t2-32)*4,0,0,0,(t1-32)*4]
                pshufb xmm9, xmm10
                ;Adds B and A to xmm9 
                movdqu xmm10, [blue_y_transparencia]
                paddusb xmm9, xmm10 

                ; 2) If the last mask is on 0 that means that the temperature was >= 32. Now we'll only check if the temperature is < 96. Then we'll combine 
                ;the masks using a PXOR. The PXOR between the two masks only sets the px to 1 if the temperature meets the second condition. 
                ;Copy temperatures onto xmm10
                movdqu xmm10, xmm0 
                ;xmm11 = [0, 0, 96, 96]
                movdqu xmm12, [caso2]
                pcmpgtd xmm12, xmm10 
                pxor xmm11, xmm12 

                ; 3) PAND leaves only the pixels that meet condition 2
                pand xmm9, xmm11 

                ; 4) POR puts the pixels that are != 0 in xmm8 
                por xmm8, xmm9 

            ;
            
            ; ----------------------------------------------------
            ; Third condition: 96 <= t < 160 
            ; ----------------------------------------------------
                ; 1) xmm9 = [0,0,0,0,0,0,0,0,255,(t2 - 96)*4,255,255 - (t2 - 96)*4,255,(t1 - 96)*4,255,255 - (t1 - 96)*4]
                movdqu xmm9, xmm0 
                movdqu xmm10, [resta96] 
                psubusb xmm9, xmm10 
                movdqu xmm10, [cuatro]
                ;xmm9 = [0,0,(t2 - 96)*4,(t1 - 96)*4]
                pmulld xmm9, xmm10
                ;We'll calculate 255 - (t - 96)*4 in another register and then we blend
                ; xmm11 = [0,0,0,0,0,0,0,0,0,0,0,255,0,0,0,255]
                movdqu xmm11, [resta_255] 
                ;xmm11 = [0,0,0,0,0,0,0,0,0,0,0,255 - (t2 - 96)*4,0,0,0,255 - (t1 - 96)*4]
                psubusb xmm11, xmm9
                movdqu xmm10, [shuffle_caso3]
                ;xmm9 = [0,0,0,0,0,0,0,0,0,(t2 - 96)*4,0,0,0,(t1 - 96)*4,0,0]
                pshufb xmm9, xmm10 
                movdqu xmm10, [transparencia_y_verde]
                ;xmm9 = [0,0,0,0,0,0,0,0,255,(t2 - 96)*4,255,0,255,(t1 - 96)*4,255,0]
                paddusb xmm9, xmm10 
                paddusb xmm9, xmm11
                

                ; 2) Uses the same logic as the previous condition
                movdqu xmm10, xmm0 
                movdqu xmm13, [caso3] 
                pcmpgtd xmm13, xmm10 
                pxor xmm12, xmm13 

                ;3) PAND leaves only the pixels that meet condition 3
                pand xmm9, xmm12 

                ; 4) POR puts the pixels that are != 0 in xmm8 
                por xmm8, xmm9
            
            ;
            
            ; ----------------------------------------------------
            ; Fourth condition: 160 <= t < 224 
            ; ----------------------------------------------------
                ;1) xmm9 = [0,0,0,0,0,0,0,0,255,255,255 - (t2 -160)*4,0,255,255,255 - (t1 - 160)*4,0]
                movdqu xmm9, xmm0 
                movdqu xmm10, [resta160]
                psubusb xmm9, xmm10 
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 
                movdqu xmm10, [resta_255] 
                psubusb xmm10, xmm9 
                movdqu xmm9, xmm10 
                movdqu xmm11, [shuffle_caso4] 
                ;xmm9 = [0,0,0,0,0,0,0,0,0,0,255 - (t2 -160)*4,0,0,0,255 - (t1 -160)*4,0]
                pshufb xmm9, xmm11 
                ;Adds R and A to xmm9
                movdqu xmm11, [red_y_transparencia]
                paddusb xmm9, xmm11 

                ;2) Uses the same logic as the previous condition
                movdqu xmm10, xmm0 
                movdqu xmm14, [caso4] 
                pcmpgtd xmm14, xmm10 
                pxor xmm13, xmm14 

                ;3)  PAND leaves only the pixels that meet condition 4
                pand xmm9, xmm13 

                ; 4) POR puts the pixels that are != 0 in xmm8 
                por xmm8, xmm9

            ;
            
            ; ----------------------------------------------
            ; Fifth condition: t >= 224 
            ; ----------------------------------------------
                ; 1) xmm9 = [0,0,0,0,0,0,0,0,255,255 - (t2 - 224)*4,0,0,255,255 - (t1 - 224)*4,0,0]
                movdqu xmm9, xmm0 
                movdqu xmm10, [resta224]
                psubusb xmm9, xmm10 
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 
                movdqu xmm10, [resta_255] 
                psubusb xmm10, xmm9 
                movdqu xmm9, xmm10 
                movdqu xmm10, [shuffle_caso5]
                ;xmm9 = [0,0,0,0,0,0,0,0,0,255 - (t2 -224)*4,0,0,0,255 - (t1 -224)*4,0,0]
                pshufb xmm9, xmm10 
                movdqu xmm10, [transparencia]
                ;Adds A to xmm9
                paddusb xmm9, xmm10 

                ; 2) Uses the same logic as the previous condition
                movdqu xmm10, xmm0 
                movdqu xmm11, [caso5] 
                pcmpgtd xmm10, xmm11 

                ;3) PAND leaves only the pixels that meet condition 5
                pand xmm9, xmm10

                ;4) POR puts the pixels that are != 0 in xmm8 
                por xmm8, xmm9
                
            ;

            ;We finally have the correct values for 2 pixels in xmm8
            
            continuar_ciclo:
            ;Stores two pixels in memory
            movq [rsi + r11], xmm8 
            ;Adds two pixels to the iterator (2 pixels = 8 bytes)
            add r11, 8 
            ;Subtracts 2 to the remaining width
            sub rdx, 2 
            jmp ciclo_ancho

        fin_ciclo_ancho:
        
        ;rsi (dst) now points to the beginning of the next row
        lea rsi, [rsi + r9] 
        ;rdi (src) now points to the beginning of the next row
        lea rdi, [rdi + r8] 
        ;Decreases remaining height
        dec rcx
        jmp ciclo_altura

    fin_ciclo_altura:
    
    ;Pops non-volatile registers out of the stack
    pop r11
    pop r10
    pop r13
    pop r12
    pop rbp
    ret
