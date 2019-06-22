.data
    welcome_string: .asciiz "Welcome to Bank Management System\n"

    array: .word 1000, 500
           .word 1001, 900
           .word 1002, 1500
           .word 1003, 5000
           .word 1004, 3000

    input1: .asciiz "\nPress 1 for operation \nPress 2 to create account: "

    choice: .asciiz "\nEnter 1 to deposit amount,\n2 to withdraw amount, \n3 for transfer : "
    
    input2: .asciiz "\nEnter account number: "

    input3: .asciiz "\nEnter amount to deposit: "

    input4: .asciiz "\nEnter amount to withdraw: "

    msg: .asciiz "\nYou don't have enough amount!!"

    msg1:.asciiz "\nEnter your account number: "

    msg2: .asciiz "\nEnter reciever's account number: "
    
    msg3: .asciiz "\nEnter ammount to transfer: "

.text

.globl main
.ent main

main:

    #calling welcome
    jal welcome

    #calling input1 function
    jal input1_function

    # $t0 = 1 or 2
    move $t0, $a0

    # hardcode $t1 = 2
    addi $t1, $0, 2

    # hardcode $t3 = 3
    addi $t3, $0, 3

    #branch if user input 2 to two
    beq $t0, $t1, two

    jal choice_message

    # $t2 = 1 2 OR 3
    move $t2, $a0

    # if choice is 2 then move to two two
    beq $t2, $t1, twotwo

    # if choice is 3 then move to three three
    beq $t2, $t3, threethree

    jal choice_one

    li $v0, 10
    syscall


    twotwo:

        jal choice_two

        li $v0, 10
        syscall

    threethree:
        jal choice_three

        li $v0, 10
        syscall

    # jal two


#Exiting main
li $v0, 10
syscall

.end main

#Welcome Function
.ent welcome
welcome:

    li $v0, 4
    la $a0, welcome_string
    syscall

jr $ra
.end welcome

# Input1 Function
.ent input1_function
input1_function:

    #Displaying input1 text
    li $v0, 4
    la $a0, input1
    syscall

    #Taking User Input, if it is 1 or 2
    li $v0, 5
    syscall

jr $ra
.end input1_function

# Choice Message
.ent choice_message
choice_message:

    #displaying choice message
    li $v0, 4
    la $a0, choice
    syscall

    #taking User input 1, 2, 3
    li $v0, 5
    syscall

    move $a0, $v0

jr $ra
.end choice_message

.ent choice_one
choice_one:

    #array address in t9
    la $t9, array

    #user wants to deposit amount

    #Displaying the message to enter account number
    li $v0, 4
    la $a0, input2
    syscall

    #Reading user's account number
    li $v0, 5
    syscall

    #saving account number to $t4
    move $t4, $v0

    #Displaying message to enter amount to deposit
    li $v0, 4
    la $a0, input3
    syscall

    #Reading user's input of amount to deposit
    li $v0, 5
    syscall

    #saving amount to deposit into $t5
    move $t5, $v0

    #setting loop variable t6 to 0
    addi $t6, $0, 0

    #setting $t7 to 5
    addi $t7, $0, 5

        addi $sp, $sp, -4
        sw $ra, 0($sp)


    loop1:


        beq $t6, $t7, exit

        #setting column index to 0 which will remain constant
        addi $a2, $0, 0

        #setting row index to loop variable
        addi $a1, $t6, 0

        jal calculate_address 

        #address is in t8
        move $s5, $v0

        lw $t8, ($s5)

        bne $t8, $t4, here

            #loading amount of that account number into s3
            lw $s3, 4($s5)

            #adding amount to deposit to actual amount
            add $s3, $s3, $t5

            #storing back to that address
            sw $s3, 4($s5)

            j exit

    here:    
        #adding 1 in loop variable
        addi $t6, $t6, 1

    j loop1

    exit:


            ######
            lw $s4, 4($s5)
            li $v0,1
            move $a0, $s4
            syscall
            ######


        lw $ra, 0($sp)

jr $ra
.end choice_one










#Choice two function
.ent choice_two
choice_two:

    #User wants to withdraw amount

    #Displaying a message to display account number
    li $v0, 4
    la $a0, input2
    syscall

    #Reading user's account number
    li $v0, 5
    syscall

    #saving account number to $t4
    move $t4, $v0

    #Display message of amount to withdraw
    li $v0, 4
    la $a0, input4
    syscall

    #Reading user's input of amount to withdraw
    li $v0, 5
    syscall

    #saving amount to withdraw into $t5
    move $t5, $v0

    #setting loop variable t6 to 0
    addi $t6, $0, 0

    #setting $t7 to 5
    addi $t7, $0, 5

        addi $sp, $sp, -4
        sw $ra, 0($sp)

    loop2:
      

        beq $t6, $t7, exit1

        #setting column index to 0 which will remain constant
        addi $a2, $0, 0

        #setting row index to loop variable
        addi $a1, $t6, 0

        jal calculate_address

        #address in $t8
        move $s5, $v0

        lw $t8, ($s5)

        bne $t8, $t4, here1

            #loading amount of that account number into s3
            lw $s3, 4($s5)

           # checking if amount is enough to withdraw
           slt $s6, $s3, $t5

           bne $s6, $0, not_enough_amount

            #detecting amount from account
            sub $s3, $s3, $t5

            sw $s3, 4($s5)

            j exit1
        
        here1:
            #adding 1 in loop variable
            addi $t6, $t6, 1

        j loop2

        exit1:

            ######
            lw $s4, 4($s5)
            li $v0,1
            move $a0, $s4
            syscall
            ######
          
    lw $ra, 0($sp)
    addi $sp, $sp, 4

jr $ra
.end choice_two





#Choice three function 
.ent choice_three
choice_three:

    #User wants to transfer amount

    


jr $ra
.end choice_three








#calculate address
.ent calculate_address
 calculate_address:

    addi $sp, $sp, -8
    sw $s6, 0($sp)
    sw $s7, 4($sp)

        #array address in t9
        la $t9, array

        #column_size = 2
        addi $s6, $0, 2

        #data_size = 4
        addi $s7, $0, 4

        # row index
        move $s0, $a1
        
        # column index
        move $s1, $a2

        # s2 = rowindex * column size
        mul $s2, $s0, $s6

        # s2 = + cloumn index
        add $s2, $s2, $s1

        # s2 = * data_size
        mul $s2, $s2, $s7

        # adding base address
        add $s2, $s2, $t9

        #returning address answer
        move $v0, $s2

        lw $s6, 0($sp)
        lw $s7, 4($sp)
        addi $sp, $sp, 8

        jr $ra 

.end calculate_address

    
    
not_enough_amount:

    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 10
    syscall

#starting two option
#create account function
.ent two
two:

jr $ra
.end two