#AUIPC测试    revise date:2021/1/24 tiger   compact mode： Text at  Address 0
#依次输出 0x00430004 0x00430014 0x00430024 0x00430034 0x00430044 0x00430054 0x00430064 0x00430074

.text
nop
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
auipc s1,0x430
add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print
addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   


#bge 测试    大于等于零跳转   递减运算 ，从正数开始向零运算revise date:2022/1/24 tiger  
#依次输出0x0000000f 0x0000000e 0x0000000d 0x0000000c 0x0000000b 0x0000000a 0x00000009 0x00000008 0x00000007 0x00000006 0x00000005 0x00000004 0x00000003 0x000000020 x000000010 x00000000
.text
addi s1,zero,15  #初始值
bge_branch:
add a0,zero,s1          
addi a7,zero,34         
ecall                  # 输出当前值
addi s1,s1,-1
bge s1,zero,bge_branch   #测试指令

addi   a7,zero,10         #停机指令
ecall                  # 系统调用


#bgeu 测试    大于跳转  递减运算 ，从正数开始向零运算  revise date:2022/2/24 tiger
#依次输出0x0000000f 0x0000000e 0x0000000d 0x0000000c 0x0000000b 0x0000000a 0x00000009 0x00000008 0x00000007 0x00000006 0x00000005 0x00000004 0x00000003 0x00000002 0x00000001 
.text


addi s1,zero,15  
addi s2,zero,1

bgeu_branch:
sub s3,s2,s1
add a0,zero,s1        
addi a7,zero,34         
ecall                  # 输出当前值
addi s1,s1,-1  
bgeu s3,s2,bgeu_branch    #当前测试指令


addi   a7,zero,10         
ecall                  # 程序暂停或退出

#blt 测试    小于0跳转   累加运算，从负数开始向零运算 revise date:2022/1/24 tiger  
#依次输出0xfffffff1 0xfffffff2 0xfffffff3 0xfffffff4 0xfffffff5 0xfffffff6 0xfffffff7 0xfffffff8 0xfffffff9 0xfffffffa 0xfffffffb 0xfffffffc 0xfffffffd 0xfffffffe 0xffffffff
.text
addi s1,zero,-15       #初始值
blt_branch:
add a0,zero,s1          
addi a7,zero,34         
ecall                  #输出当前值
addi s1,s1,1 
blt s1,zero,blt_branch     #当前指令


addi   a7,zero,10    
ecall                  #暂停或退出

#bltu 测试    小于等于零跳转     累加运算，从负数开始向零运算  revise date:2022/1/24 tiger  
#依次输出0xfffffff1 0xfffffff2 0xfffffff3 0xfffffff4 0xfffffff5 0xfffffff6 0xfffffff7 0xfffffff8 0xfffffff9 0xfffffffa 0xfffffffb 0xfffffffc 0xfffffffd 0xfffffffe 0xffffffff 0x00000000
.text

addi s1,zero,-15       #初始值
bltu_branch:
add a0,zero,s1          
addi a7,zero,34         
ecall                  #输出当前值
addi s1,s1,1  
bltu zero,s1,bltu_branch   
add a0,zero,s1          
addi a7,zero,34         
ecall                  #输出当前值
end:
addi   a7,zero,10         
ecall                  # 暂停或退出
#LB测试    revise date:2021/1/24 tiger
#依次输出 0xffffff81 0xffffff82 0xffffff83 0xffffff84 0xffffff85 0xffffff86 0xffffff87 0xffffff88 0xffffff89 0xffffff8a 0xffffff8b 0xffffff8c 0xffffff8d 0xffffff8e 0xffffff8f 0xffffff90 0xffffff91 0xffffff92 0xffffff93 0xffffff94 0xffffff95 0xffffff96 0xffffff97 0xffffff98 0xffffff99 0xffffff9a 0xffffff9b 0xffffff9c 0xffffff9d 0xffffff9e 0xffffff9f 0xffffffa0
.text
addi t1,zero,0     #init_addr 
addi t3,zero,16     #counter
nop

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列
addi s1,zero,  0x84
slli s1,s1,8
addi s1,s1,0x83 
addi s2,zero,  0x04
slli s2,s2,8
addi s2,s2,0x04
slli s1,s1,8
addi s1,s1,0x82 
slli s1,s1,8
addi s1,s1,0x81
slli s2,s2,8
addi s2,s2,0x04
slli s2,s2,8
addi s2,s2,0x04    #    init_data= 0x84838281 next_data=init_data+ 0x04040404

lb_store:
sw s1,(t1)
add s1,s1,s2   #data +1
addi t1,t1,4    # addr +4  
addi t3,t3,-1   #counter
bne t3,zero,lb_store

addi t3,zero,32   #循环次数
addi t1,zero,0    # addr 
lb_branch:
lb s1,(t1)         #测试指令
add a0,zero,s1          
addi a7,zero,34         #输出
ecall                  
addi t1,t1, 1    
addi t3,t3, -1    
bne t3,zero,lb_branch



addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
#LBU 测试   revise date:2021/1/24 tiger
#依次输出   0x00000081 0x00000082 0x00000083 0x00000084 0x00000085 0x00000086 0x00000087 0x00000088 0x00000089 0x0000008a 0x0000008b 0x0000008c 0x0000008d 0x0000008e 0x0000008f 0x00000090 0x00000091 0x00000092 0x00000093 0x00000094 0x00000095 0x00000096 0x00000097 0x00000098 0x00000099 0x0000009a 0x0000009b 0x0000009c 0x0000009d 0x0000009e 0x0000009f 0x000000a0
.text

addi t1,zero,0     #init_addr 
addi t3,zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列
addi s1,zero,  0x84
slli s1,s1,8
addi s1,s1,0x83 
addi s2,zero,  0x04
slli s2,s2,8
addi s2,s2,0x04
slli s1,s1,8
addi s1,s1,0x82 
slli s1,s1,8
addi s1,s1,0x81
slli s2,s2,8
addi s2,s2,0x04
slli s2,s2,8
addi s2,s2,0x04    #    init_data= 0x84838281 next_data=init_data+ 0x04040404



lbu_store:
sw s1,(t1)
add s1,s1,s2   #data +1
addi t1,t1,4    # addr +4  
addi t3,t3,-1   #counter
bne t3,zero,lbu_store

addi t3,zero,32
addi t1,zero,0    # addr +4  
lbu_branch:
lbu s1,(t1)     #测试指令
add a0,zero,s1          
addi a7,zero,34         
ecall                  # 输出
addi t1,t1, 1    
addi t3,t3, -1    
bne t3,zero,lbu_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
#LH 测试    revise date:2021/1/24 tiger
#依次输出  0xffff8281 0xffff8483 0xffff8685 0xffff8887 0xffff8a89 0xffff8c8b 0xffff8e8d 0xffff908f 0xffff9291 0xffff9493 0xffff9695 0xffff9897 0xffff9a99 0xffff9c9b 0xffff9e9d 0xffffa09f 0xffffa2a1 0xffffa4a3 0xffffa6a5 0xffffa8a7 0xffffaaa9 0xffffacab 0xffffaead 0xffffb0af 0xffffb2b1 0xffffb4b3 0xffffb6b5 0xffffb8b7 0xffffbab9 0xffffbcbb 0xffffbebd 0xffffc0bf
.text

addi t1,zero,0     #init_addr 
addi t3,zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列

addi s1,zero,  0x84
slli s1,s1,8
addi s1,s1,0x83 
addi s2,zero,  0x04
slli s2,s2,8
addi s2,s2,0x04
slli s1,s1,8
addi s1,s1,0x82 
slli s1,s1,8
addi s1,s1,0x81
slli s2,s2,8
addi s2,s2,0x04
slli s2,s2,8
addi s2,s2,0x04    #    init_data= 0x84838281 next_data=init_data+ 0x04040404


lh_store:
sw s1,(t1)
add s1,s1,s2   #data +1
addi t1,t1,4    # addr +4  
addi t3,t3,-1   #counter
bne t3,zero,lh_store

addi t3,zero,32
addi t1,zero,0    # addr  
lh_branch:
lh s1,(t1)     #测试指令
add a0,zero,s1          
addi a7,zero,34         
ecall                  # print
addi t1,t1, 2    
addi t3,t3, -1    
bne t3,zero,lh_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   

#LHU 测试   revise date:2021/1/24 tiger
#依次输出  0x00008281 0x00008483 0x00008685 0x00008887 0x00008a89 0x00008c8b 0x00008e8d 0x0000908f 0x00009291 0x00009493 0x00009695 0x00009897 0x00009a99 0x00009c9b 0x00009e9d 0x0000a09f 0x0000a2a1 0x0000a4a3 0x0000a6a5 0x0000a8a7 0x0000aaa9 0x0000acab 0x0000aead 0x0000b0af 0x0000b2b1 0x0000b4b3 0x0000b6b5 0x0000b8b7 0x0000bab9 0x0000bcbb 0x0000bebd 0x0000c0bf
.text

addi t1,zero,0     #init_addr 
addi t3,zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列

addi s1,zero,  0x84
slli s1,s1,8
addi s1,s1,0x83 
addi s2,zero,  0x04
slli s2,s2,8
addi s2,s2,0x04
slli s1,s1,8
addi s1,s1,0x82 
slli s1,s1,8
addi s1,s1,0x81
slli s2,s2,8
addi s2,s2,0x04
slli s2,s2,8
addi s2,s2,0x04    #    init_data= 0x84838281 next_data=init_data+ 0x04040404

lhu_store:
sw s1,(t1)
add s1,s1,s2   #data +1
addi t1,t1,4    # addr +4  
addi t3,t3,-1   #counter
bne t3,zero,lhu_store

addi t3,zero,32   #循环次数
addi t1,zero,0    # addr
lhu_branch:
lhu s1,(t1)     #测试指令
add a0,zero,s1          
addi a7,zero,34         
ecall                  # print
addi t1,t1, 2    
addi t3,t3, -1    
bne t3,zero,lhu_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
#LUI测试    revise date:2021/1/24 tiger
#依次输出  0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000 0xfedcffff 0x0ba98000 0x07654000 0x03210000

.text

addi t3,zero,   0x8

lui_branch:
lui s1,   0xFEDC0 
addi s0,zero, -1
srli  s0,s0,16
or s1,s1,s0

add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall    
lui s1,   0xBA98
add a0,zero,s1          
ecall    
lui s1,   0x7654     
add a0,zero,s1          
ecall    
lui s1,   0x3210     
add a0,zero,s1          
ecall    
                           # print
addi t3,t3, -1    
bne t3,zero,lui_branch

addi   a7,zero,10         # system call for exit
ecall                     # we are out of here.   


#SB 测试    revise date:2018/3/14 tiger
#依次输出   0x00000000 0x00000001 0x00000002 0x00000003 0x00000004 0x00000005 0x00000006 0x00000007 0x00000008 0x00000009 0x0000000a 0x0000000b 0x0000000c 0x0000000d 0x0000000e 0x0000000f 0x00000010 0x00000011 0x00000012 0x00000013 0x00000014 0x00000015 0x00000016 0x00000017 0x00000018 0x00000019 0x0000001a 0x0000001b 0x0000001c 0x0000001d 0x0000001e 0x0000001f 0x03020100 0x07060504 0x0b0a0908 0x0f0e0d0c 0x13121110 0x17161514 0x1b1a1918 0x1f1e1d1c
.text

addi t1,zero,0     #init_addr 
addi t3,zero,32     #counter

#sb写入 01,02,03,04
addi s1,zero, 0x00  #
addi s2,zero, 0x01  #

sb_store:
sb s1,(t1)
add a0,zero,s1          
addi a7,zero,34        # system call for print
ecall                  # print

add s1,s1,s2          #data +1
addi t1,t1,1           # addr ++  
addi t3,t3,-1          #counter
bne t3,zero,sb_store

addi t3,zero,8
addi t1,zero,0    # addr   
sb_branch:
lw s1,(t1)       #读出数据 
add a0,zero,s1          
addi a7,zero,34        # system call for print
ecall                  # print
addi t1,t1,4    
addi t3,t3, -1    
bne t3,zero,sb_branch

addi   a7,zero,10      # system call for exit
ecall                  # we are out of here.   

#SH 测试    revise date:2018/3/14 tiger
#依次输出 0x00000001 0x00000002 0x00000003 0x00000004 0x00000005 0x00000006 0x00000007 0x00000008 0x00000009 0x0000000a 0x0000000b 0x0000000c 0x0000000d 0x0000000e 0x0000000f 0x00000010 0x00000011 0x00000012 0x00000013 0x00000014 0x00000015 0x00000016 0x00000017 0x00000018 0x00000019 0x0000001a 0x0000001b 0x0000001c 0x0000001d 0x0000001e 0x0000001f 0x00000020 0x00020001 0x00040003 0x00060005 0x00080007 0x000a0009 0x000c000b 0x000e000d 0x0010000f 0x00120011 0x00140013 0x00160015 0x00180017 0x001a0019 0x001c001b 0x001e001d 0x0020001f

.text

addi t1,zero,0     #init_addr 
addi t3,zero,32     #counter

#SH脨麓脠毛 01,02,03,04
addi s1,zero, 0x01  #
addi s2,zero, 0x01  #
sh_store:
sh s1,(t1)
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print

add s1,s1,s2   #data +1
addi t1,t1,2    # addr +4  
addi t3,t3,-1   #counter
bne t3,zero,sh_store


addi t3,zero,16
addi t1,zero,0    # addr 
sh_branch:
lw s1,(t1)     
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t1,t1,4    
addi t3,t3, -1    
bne t3,zero,sh_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
#sll   revise date:2018/3/12 tiger
#依次输出  0x00000876 0x00008760 0x00087600 0x00876000 0x08760000 0x87600000 0x76000000 0x60000000 0x00000000

.text

addi t0,zero,1     
addi t1,zero,3     
addi s1,zero,  0x8
slli s1,s1,8
addi s1,s1,0x76     

add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print

addi t3,zero,8

sll_branch:
sll s1,s1,t0       #1
sll s1,s1,t1       #娴嬭瘯
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t3,t3, -1    
bne t3,zero,sll_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   






#sltiu 测试    revise date:2021/1/24 tiger
#依次输出  0x00001997 0x00001996 0x00001995 0x00001994 0x00001993 0x00001992 0x00001991 0x00001990 0x0000198f 0x0000198e 0x0000198d 0x0000198c 0x0000198b 0x0000198a 0x00001989 0x00001988 0x00001987 0x00001986 0x00001985 0x00001984 0x00001983 0x00001982 0x00001981 0x00001980 0x0000197f 0x0000197e 0x0000197d 0x0000197c 0x0000197b 0x0000197a 0x00001979 0x00001978 0x00001977 0x00001976 0x00001975 0x00001974 0x00001973 0x00001972 0x00001971 0x00001970 0x0000196f 0x0000196e 0x0000196d 0x0000196c 0x0000196b 0x0000196a 0x00001969 0x00001968 0x00001967 0x00001966 0x00001965 0x00001964 0x00001963 0x00001962 0x00001961 0x00001960 0x0000195f 0x0000195e 0x0000195d 0x0000195c 0x0000195b 0x0000195a 0x00001959 0x00001958 0x00001957 0x00001956 0x00001955 0x00001954 0x00001953 0x00001952 0x00001951 0x00001950 0x0000194f 0x0000194e 0x0000194d 0x0000194c 0x0000194b 0x0000194a 0x00001949

.text
addi t0,zero,-1    
addi t1,zero,0     

addi s0,zero,0x19
slli s0,s0,8
addi s1,zero,0x97


sltiu_branch:
add a0,s0,s1          
addi a7,zero,34        # system call for print
ecall                  # print
add s1,s1,t0     
sltiu t1,s1, 0x49
beq t1,zero,sltiu_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
#sra移位测试    revise date:2021/1/24 tiger
#依次输出  0x87600000 0xf8760000 0xff876000 0xfff87600 0xffff8760 0xfffff876 0xffffff87 0xfffffff8 0xffffffff

.text

addi t0,zero,1     #sll 移位次数
addi t1,zero,3     #sll 移位次数
addi s1,zero,  0x8
slli s1,s1,8
addi s1,s1,0x76     

slli s1,s1,20     #

add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print

addi t3,zero,8

sra_branch:
sra s1,s1,t0     #先移1位
sra s1,s1,t1     #再移3位
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t3,t3, -1    
bne t3,zero,sra_branch   #循环8次

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
#SRLV移位测试    revise date:2021/1/24 tiger
#依次输出  0x87600000 0x08760000 0x00876000 0x00087600 0x00008760 0x00000876 0x00000087 0x00000008 0x00000000
.text

addi t0,zero,1     #sllv 移位次数
addi t1,zero,3     #sllv 移位次数
addi s1,zero,  0x8
slli s1,s1,8
addi s1,s1,0x76     

slli s1,s1,20     #

add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print

addi t3,zero,8

srl_branch:
srl s1,s1,t0     #先移1位
srl s1,s1,t1     #再移3位
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t3,t3, -1    
bne t3,zero,srl_branch   #循环8次

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   


#XOR测试    revise date:2021/1/24 tiger
# 0x00007777 xor   0xffffffff =  0xffff8888 
# 0xffff8888 xor   0xffffffff =  0x00007777 
#依次输出 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777

.text

addi t0,zero,-1     #
addi s1,zero,  0x77
slli s1,s1,8
addi s1,s1,0x77



add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print

addi t3,zero, 0x10

xor_branch:
xor s1,s1,t0     #先移1位
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t3,t3, -1    
bne t3,zero,xor_branch   #循环8次

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   

