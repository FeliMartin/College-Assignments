global temperature_asm
section .rodata

    tres_fp: dq 3.0
    sacar_a: times 2 dq 0x0000000000ffffff ;ya esta dado vuelta
    shuf_para_rgb: db 0x00, 0x80, 0x01, 0x80, 0x02, 0x80, 0x80, 0x80, 0x80, 0x80, 0x08, 0x80, 0x09, 0x80, 0xa, 0x80 ;ya esta dado vuelta
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
    caso1: db 0x20, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;dd 0x00, 0x00, 0x20, 0x20
    caso2: db 0x60, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;dd 0x00, 0x00, 0x60, 0x60
    caso3: db 0xa0, 0x00, 0x00, 0x00, 0xa0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;dd 0x00, 0x00, 0xa0, 0xa0
    caso4: db 0xe0, 0x00, 0x00, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;dd 0x00, 0x00, 0xe0, 0xe0 
    caso5: db 0xdf, 0x00, 0x00, 0x00, 0xdf, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;dd 0x00, 0x00, 0xdf, 0xdf
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
    push r10 ;Aca vamos a guardar una copia de width
    push r11 ;Iterador para ciclo_ancho
    mov rbp, rsp
    mov r10, rdx
    
    ;Vamos a iterar por fila, de a 2 pixeles
    ;El ancho de las imagenes es multiplo de 8, por lo que podemos iterar de a 2 pixeles
    ciclo_altura:
        cmp rcx, 0
        je fin_ciclo_altura
        mov rdx, r10 ;Resetamos el valor del width 

        xor r11, r11 ;Ponemos iterador en 0
        ciclo_ancho:
            cmp rdx, 0
            je fin_ciclo_ancho

            ;----- CALCULAR LA TEMPERATURA DE 2 PIXELES -----
            ;Cargamos dos pixeles en xmm0 extendidos a 0
            PMOVZXDQ xmm0, [rdi + r11] ;xmm0 = [0,0,0,0,a,r,g,b,0,0,0,0,a,r,g,b] 
            movdqu xmm1, [sacar_a] ;Cargamos la mascara para sacar la transparencia (sacar_a) en xmm1
            ;xmm1 = [0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff]
            
            pand xmm0, xmm1 ;Hacemos AND bit a bit entre xmm0 y xmm1 (limpiamos la transparencia)
            
            movdqu xmm1, [shuf_para_rgb]
            pshufb xmm0, xmm1 ;Hacemos shuffle a xmm0 tal que quede asi: [0x000r, 0x000g, 0x000b, 0x0000, 0x0000, 0x000r, 0x000g, 0x000b]
            
            ;Sumamos horizontalmente dos veces con saturacion: phaddsw xmm0, xmm0
            ;xmm0 = [0x000r, 0x000g, 0x000b, 0x0000, 0x0000, 0x000r, 0x000g, 0x000b]
            phaddsw xmm0, xmm0 ;xmm0 = [r+g, b, r, g+b , repetido]
            phaddsw xmm0, xmm0 ;xmm0 = [r2+g2+b2, r1+g1+b1, r2+g2+b2, ...] = [b', a', b', ...] (cada sumatoria ocupa 1 word)
            
            ;El shuffle por word (low o high) funciona distinto: toma tres params xmm1, xmm2, imm8
            ;Mezcla los contenidos de xmm2 en base al imm8 y los guarda en xmm1
            ;Ej, si imm8 = 00 11 01 10 00 => entonces word 0 de xmm1 = word 0 de xmm2, word 1 de xmm0 = word 2 de xmm2 y asi..
            ;Notar que este shuffle no te deja poner bytes en 0
            ;Vamos a tener que hacer un shuffle y despues usar una mascara para borrar el exceso  
            
            pshuflw xmm0, xmm0, 00010000b ;Hacemos un shuffle a xmm0 para poder convertir la suma de los rgb en DP Floats
            movdqu xmm1, [mask_para_cvt]
            pand xmm0, xmm1
            ;xmm0 = [0, 0, 0, 0, 0, b', 0, a'] (cada digito ocupa un word)
            
            
            cvtdq2pd xmm0, xmm0 ;(convierte los primeros dos doubleword integers en dos DP Floats)
            ;xmm0 = [b' , a'] en double precision
            
            ;Cargamos tres_fp como un DP Float 2 veces en xmm1 (Lo cargamos una vez en la parte alta, y otra en la baja)
            movhpd xmm1, [tres_fp]
            movlpd xmm1, [tres_fp]
            ;xmm1 = [3, 3] en double precision
            
            ;Dividimos ambas sumas por 3
            divpd xmm0, xmm1 ;Ahora xmm0 = [b'/3 , a'/3]
            
            ;Convertimos los dos valores en enteros con truncacion
            cvttpd2dq xmm0, xmm0 ;(Deja los 64 bits altos en 0)
            ;xmm0 = [00 .... , 0x00, t2, 0x00, t1]
            ;----- CALCULAR LA TEMPERATURA DE 2 PIXELES -----

            ; entonces tenemos en xmm0 = [0,0,t2,t1], como a lo sumo su valor es 255, ocupan "1 byte" de la double word, seria xmm0 = [0x00...,0x00,0x00,0x00,t2,0x00,0x00,0x00,t1]
            ; entonces en la posicion 0 esta t1 y en a posicion 4 esta t2.
            ; ahora calculamos todos los if, la idea es tener un registro de resultado final, xmm8, en el cual dependiendo que condicion cumple, 
            ; guarda el pixel correspondiente de cada temperatura.

            pxor xmm8, xmm8 ; lo seteamos en 0

            ; pasos para cada condicion: 
            ; 1) armar un xmm con los pixeles que deberian ir si se cumple la condicion. 
            ; 2) calcular la comparacion, eso nos da una mascara.
            ; 3) hacer un PAND con esta mascara y el xmm anterior, ahi los van a quedar los correspondientes pixeles que cumplen la condicion, sino 0.
            ; 4) hacer un POR con el xmm8, el registro de resultado final, para que quede en el registro final.
            
            ; -----------------------------------------------
            ; ahora vamos por la primera condicion: t < 32 
            ; -----------------------------------------------
                ; 1) armamos el pixel para que quede de la forma xmm9 = [0,0,0,0,0,0,0,0,255,0,0,128 + t2*4,255,0,0,128 + t1*4]
                movdqu xmm9, xmm0 ; creamos una copia de las temperaturas  xmm0 = [0x00...,0x00,0x00,0x00,t2,0x00,0x00,0x00,t1]
                ; armamos un xmm para multiplicar por 4 = [4,4,4,4] (32 bits)
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 ; ahora en xmm9 tenemos = [0,0,t2*4,t1*4] 
                movdqu xmm10, [num_y_transparencia] 
                paddusb xmm9, xmm10 ; ahora tengo completo xmm9 = [0,0,0,0,0,0,0,0,255,0,0,128 + t2*4,255,0,0,128 + t1*4] (la suma es a lo sumo 128 + 31*4 = 252 no se pasa)

                ; 2) ahora hacemos la comparacion para conseguir la mascara
                movdqu xmm10, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm11, [caso1] ; le ponemos el numero 32
                pcmpgtd xmm11, xmm10 ; ahora en xmm11 tenemos xmm11 = [0,0,0/1,0/1] (0/1 es o todos los bits de la doubleword en 0 o en 1)(1 si t < 32, 0 cc)
                ;(lo guardamos para despues nos va a servir para el caso 2) 

                ; 3) ahora hacemos el PAND para que quede solo los pixeles con la t que cumple la condicion
                pand xmm9, xmm11 ; ahora tenemos en xmm9 = [0,0,px2/0,px1/0]

                ; 4) y ahora juntamos este xmm con la solucion que vamos a tener final en xmm8
                por xmm8, xmm9 

            ; 
            
            ;----------------------------------------------------
            ; ahora vamos por la segunda condicion: 32 <= t < 96 
            ; ----------------------------------------------------
                ; 1) armamos el pixel para que quede de la forma xmm9 = [0,0,0,0,0,0,0,0,255,0,(t2 - 32)*4,255,255,0,(t1 - 32)*4,255]
                movdqu xmm9, xmm0 ; creamos una copia de las temperaturas 
                movdqu xmm10, [resta32]
                psubusb xmm9, xmm10 ; ahora tenemos t1 - 32 y t2 - 32
                ; armamos un xmm para multiplicar por 4 = [4,4,4,4] (32 bits)
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 ; ahora en xmm9 tenemos = [0,0,(t2-32)*4,(t1-32)*4] (es a lo sumo 252 no se va de rango)
                movdqu xmm10, [shuffle_caso2]
                pshufb xmm9, xmm10 ; ahora en xmm9 = [0,0,0,0,0,0,0,0,0,0,0,(t2-32)*4,0,0,0,(t1-32)*4], nos falta sumar 255 al blue y la transparencia
                movdqu xmm10, [blue_y_transparencia]
                paddusb xmm9, xmm10 ; ahora en xmm9 = [0,0,0,0,0,0,0,0,255,0,(t2 - 32)*4,255,255,0,(t1 - 32)*4,255]

                ; 2) ahora hacemos la comparacion para hacer la mascara, la idea es usar la mascara anterior, ya que si quedaron en 0 es porque eran >= a 32 
                ; entonces solo hacemos ahora una mascara para ver si son < 96 y despues combinamos mascaras con un pxor, ya que tenemos solo estas posibilidades:
                ; a) 0/1 (t>=32 y t < 96) b) 1/1 (t < 32 y t < 96) c) 1/0 (t < 32 y t >= 96 !IMPOSIBLE) d) 0/0 (t >= 32 y t >= 96)
                ; entonces con un pxor nos quedariamos con la opcion a) que es la que queremos y nunca puede dar el caso c) porque seria imposible, entonces el 
                ;pxor nos daria 1 si y solo si se cumple el caso a)

                movdqu xmm10, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm12, [caso2] ; le ponemos el numero 96
                pcmpgtd xmm12, xmm10 ; ahora en xmm12 tenemos xmm12 = [0,0,0/1,0/1] (0/1 es o todos los bits de la doubleword en 0 o en 1)(1 si t < 96, 0 cc)
                pxor xmm11, xmm12 ; ahora en xmm11 verdaderamente tenemos la mascara correspondiente (guardamos xmm12 para el proximo caso)

                ; 3) ahora hacemos el PAND para que quede solo los pixeles con la t que cumple la condicion
                pand xmm9, xmm11 ; ahora tenemos en xmm9 = [0,0,px2/0,px1/0]

                ; 4) y ahora juntamos este xmm con la solucion que vamos a tener final en xmm8
                por xmm8, xmm9 

            ;
            
            ; ----------------------------------------------------
            ; ahora vamos por la tercera condicion: 96 <= t < 160 
            ; ----------------------------------------------------
                ; 1) armamos el pixel para que quede de la forma xmm9 = [0,0,0,0,0,0,0,0,255,(t2 - 96)*4,255,255 - (t2 - 96)*4,255,(t1 - 96)*4,255,255 - (t1 - 96)*4]
                movdqu xmm9, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm10, [resta96] 
                psubusb xmm9, xmm10 ; ahora tenemos t1 - 96 y t2 - 96
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 ; ahora tenemos en xmm9 = [0,0,(t2 - 96)*4,(t1 - 96)*4] (a lo sumo 252 no se va de rango)
                ; ahora para hacer el 255 - (t - 96)*4, lo hacemos en otro registro y despues hacemos un blend
                movdqu xmm11, [resta_255] ; xmm11 = [0,0,0,0,0,0,0,0,0,0,0,255,0,0,0,255]
                psubusb xmm11, xmm9 ; ahora en xmm11 = [0,0,0,0,0,0,0,0,0,0,0,255 - (t2 - 96)*4,0,0,0,255 - (t1 - 96)*4], como este valor va en blue, ya esta en la posicion correcta
                movdqu xmm10, [shuffle_caso3]
                pshufb xmm9, xmm10 ; ahora xmm9 = [0,0,0,0,0,0,0,0,0,(t2 - 96)*4,0,0,0,(t1 - 96)*4,0,0]
                movdqu xmm10, [transparencia_y_verde]
                paddusb xmm9, xmm10 ; ahora xmm9 = [0,0,0,0,0,0,0,0,255,(t2 - 96)*4,255,0,255,(t1 - 96)*4,255,0]
                paddusb xmm9, xmm11
                ;movdqu xmm10, xmm0 ; lo guardamos en xmm10 para usar xmm0 para el blend
                ;movdqu xmm0, [blend_caso_3]
                ;pblendvb xmm9, xmm11 ; ahora ya queda armado xmm9 = [0,0,0,0,0,0,0,0,255,(t2 - 96)*4,255,255 - (t2 - 96)*4,255,(t1 - 96)*4,255,255 - (t1 - 96)*4]
                ;movdqu xmm0, xmm10 ; restauramos el valor de xmm0

                ; 2) usamos la misma logica que la condicion anterior

                movdqu xmm10, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm13, [caso3] ; le ponemos el numero 160
                pcmpgtd xmm13, xmm10 ; ahora en xmm13 tenemos xmm13 = [0,0,0/1,0/1] (0/1 es o todos los bits de la doubleword en 0 o en 1)(1 si t < 160, 0 cc)
                ;(lo guardamos para el proximo caso)
                pxor xmm12, xmm13 ; ahora en xmm12 verdaderamente tenemos la mascara correspondiente

                ;3)  ahora hacemos el PAND para que quede solo los pixeles con la t que cumple la condicion
                pand xmm9, xmm12 ; ahora tenemos en xmm9 = [0,0,px2/0,px1/0]

                ; 4) y ahora juntamos este xmm con la solucion que vamos a tener final en xmm8
                por xmm8, xmm9
            
            ;
            
            ; ----------------------------------------------------
            ; ahora vamos por la cuarta condicion: 160 <= t < 224 
            ; ----------------------------------------------------
                ;1) armamos el pixel para que quede de la forma xmm9 = [0,0,0,0,0,0,0,0,255,255,255 - (t2 -160)*4,0,255,255,255 - (t1 - 160)*4,0]
                movdqu xmm9, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm10, [resta160]
                psubusb xmm9, xmm10 ; ahora en xmm9 tenemos t2 - 160 y  t1 - 160
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 ; ahora en xmm9 tenemos (t2 -160)*4 y (t1 -160)*4
                movdqu xmm10, [resta_255] ; ahora xmm10 = [0,0,0,0,0,0,0,0,0,0,0,255,0,0,0,255]
                psubusb xmm10, xmm9 ; ahora en xmm10 tengo xmm10 = [0,0,0,0,0,0,0,0,0,0,0,255 - (t2 -160)*4,0,0,0,255 - (t1 -160)*4], falta ordenarlos
                movdqu xmm9, xmm10 ; lo volvemos a poner en xmm9
                movdqu xmm11, [shuffle_caso4] 
                pshufb xmm9, xmm11 ; ahora en xmm9 = [0,0,0,0,0,0,0,0,0,0,255 - (t2 -160)*4,0,0,0,255 - (t1 -160)*4,0], solo falta la transparencia y rojo en 255
                movdqu xmm11, [red_y_transparencia]
                paddusb xmm9, xmm11 ; ahora tenemos listo el xmm9 = [0,0,0,0,0,0,0,0,255,255,255 - (t2 -160)*4,0,255,255,255 - (t1 - 160)*4,0]

                ;2) usamos la misma logica que la condicion anterior

                movdqu xmm10, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm14, [caso4] ; le ponemos el numero 224
                pcmpgtd xmm14, xmm10 ; ahora en xmm14 tenemos xmm14 = [0,0,0/1,0/1] (0/1 es o todos los bits de la doubleword en 0 o en 1)(1 si t < 160, 0 cc)
                ;(lo guardamos para el proximo caso)
                pxor xmm13, xmm14 ; ahora en xmm13 verdaderamente tenemos la mascara correspondiente

                ;3)  ahora hacemos el PAND para que quede solo los pixeles con la t que cumple la condicion
                pand xmm9, xmm13 ; ahora tenemos en xmm9 = [0,0,px2/0,px1/0]

                ; 4) y ahora juntamos este xmm con la solucion que vamos a tener final en xmm8
                por xmm8, xmm9

            ;
            
            ; ----------------------------------------------
            ; ahora vamos por la quinta condicion: t >= 224 
            ; ----------------------------------------------
                ; 1) armamos el pixel para que quede de la forma xmm9 = [0,0,0,0,0,0,0,0,255,255 - (t2 - 224)*4,0,0,255,255 - (t1 - 224)*4,0,0]
                movdqu xmm9, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm10, [resta224]
                psubusb xmm9, xmm10 ; ahora en xmm9 tenemos t2 - 224 y  t1 - 224
                movdqu xmm10, [cuatro]
                pmulld xmm9, xmm10 ; ahora en xmm9 tenemos (t2 -224)*4 y (t1 -224)*4
                movdqu xmm10, [resta_255] ; ahora xmm10 = [0,0,0,0,0,0,0,0,0,0,0,255,0,0,0,255]
                psubusb xmm10, xmm9 ; ahora en xmm10 tengo xmm10 = [0,0,0,0,0,0,0,0,0,0,0,255 - (t2 -224)*4,0,0,0,255 - (t1 -224)*4], falta ordenarlos
                movdqu xmm9, xmm10 ; lo volvemos a poner en xmm9
                movdqu xmm10, [shuffle_caso5]
                pshufb xmm9, xmm10 ; ahora en xmm9 = [0,0,0,0,0,0,0,0,0,255 - (t2 -224)*4,0,0,0,255 - (t1 -224)*4,0,0]
                movdqu xmm10, [transparencia]
                paddusb xmm9, xmm10 ; listo ahora xmm9 = [0,0,0,0,0,0,0,0,255,255 - (t2 - 224)*4,0,0,255,255 - (t1 - 224)*4,0,0]

                ; 2) usamos la misma logica que la condicion anterior

                movdqu xmm10, xmm0 ; creamos una copia de las temperaturas
                movdqu xmm11, [caso5] ; ponemos el valor de 223 para el > ya que >= 224 == > 223
                pcmpgtd xmm10, xmm11 ; en este caso va al revez, nos queda 1 si el valor es mayor o igual a 224 o 0  si es menor

                ;3)  ahora hacemos el PAND para que quede solo los pixeles con la t que cumple la condicion
                pand xmm9, xmm10 ; ahora tenemos en xmm9 = [0,0,px2/0,px1/0]

                ; 4) y ahora juntamos este xmm con la solucion que vamos a tener final en xmm8
                por xmm8, xmm9
                
            ;

            ; ahora finalmente en xmm8 tenemos el resultado final que vamos a mandar a dst
            
            continuar_ciclo:
            ;xmm8 ahora tiene los valores correctos de cada pixel
            movq [rsi + r11], xmm8 ;Cargamos los dos pixeles correctos en memoria
            add r11, 8 ;Sumamos 2 al iterador
            sub rdx, 2 ;Restamos 2 al ancho restenta de la fila
            jmp ciclo_ancho

        fin_ciclo_ancho:
        
        lea rsi, [rsi + r9] ;rsi (dst) ahora apunta al inicio de la fila siguiente
        lea rdi, [rdi + r8] ;rdi (src) ahora apunta al inicio de la fila siguiente 
        dec rcx
        jmp ciclo_altura

    fin_ciclo_altura:
    
    ;Cuidado con el orden de los pops
    pop r11
    pop r10
    pop r13
    pop r12
    pop rbp
    ret
