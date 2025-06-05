Include Irvine32.inc
.386
.model flat, stdcall
.stack 4096

.data

msg1 byte 'Enter a string: ', 0
filehandler handle ?
data byte 1000 DUP (?) 
filename byte 'Student_Data.txt', 0
data_len dword ?
var dword ?

msg2 byte 'Enter roll number of Student: ', 0
msg3 byte 'Enter name of Students: ', 0
msg4 byte 'Enter section of Student: ', 0
msg5 byte 'Enter obtained Marks of student: ', 0
msg6 byte 'Enter "n" to exit, enter any other key to add new record:', 0
text byte 'Hello' , 0Ah, 'My name is fahid', 0

header1 byte 'Roll No', 0
header2 byte 'Name', 0
header3 byte 'Section', 0
header4 byte 'Marks', 0

roll_no byte 10 Dup (?)
roll_no_len dword ?

sname byte 50 Dup (?)
name_len dword ?

section byte 10 Dup (?)
section_len dword ?

marks byte 10 Dup (?)
marks_len dword ?

combined_str byte 100 dup (?)
combined_str_len dword ?

roll_no_arr byte 100 Dup (10 Dup (?))
name_arr byte 100 Dup (50 Dup (?))
section_arr byte 100 Dup (10 Dup (?))
marks_arr byte  100 Dup (10 Dup (?))

total_elements dword 0

var2 dword ?

menue1 byte 'Enter 1 to enter new record', 0
menue2 byte 'Enter 2 to display records', 0
menue3 byte 'Enter 3 to sort by Name', 0
menue4 byte 'Enter 4 to sort by marks', 0
menue5 byte 'Enter 5 to exit', 0

.code

clear_string_arrays Proc
	pushad

	mov edx, offset roll_no_arr
	mov ecx, lengthof roll_no_arr
	mov esi, 0
	label1:
		mov byte ptr [edx + esi], 0
		inc esi
	loop label1

	mov edx, offset name_arr
	mov ecx, lengthof name_arr
	mov esi, 0
	label2:
		mov byte ptr [edx + esi], 0
		inc esi
	loop label2

	mov edx, offset section_arr
	mov ecx, lengthof section_arr
	mov esi, 0
	label3:
		mov byte ptr [edx + esi], 0
		inc esi
	loop label3

	mov edx, offset marks_arr
	mov ecx, lengthof marks_arr
	mov esi, 0
	label4:
		mov byte ptr [edx + esi], 0
		inc esi
	loop label4
	mov total_elements, 0

	popad
	ret
clear_string_arrays endp

read_from_file Proc 
	
	
	pushad

	call clear_string_arrays
	mov edx, offset filename
	call openInputFile
	mov filehandler, eax
	mov edx, offset data
	mov ecx, lengthof data
	call readFromFile 
	mov data_len, eax
	
	mov eax, filehandler
	call closefile

	popad
	ret 
read_from_file endp

write_to_file Proc 
	
	
	pushad

	mov edx, offset filename
	call createOutputFile
	mov filehandler, eax
	mov edx, offset data
	mov ecx, data_len
	call writetofile
	
	mov eax, filehandler
	call closefile

	popad
	ret 
write_to_file endp

take_input Proc
	pushad
	call crlf
	mov edx, offset msg2
	call writestring
	mov edx, offset roll_no
	mov ecx, lengthof roll_no
	call readstring
	mov roll_no_len, eax

	mov edx, offset msg3
	call writestring
	mov edx, offset sname
	mov ecx, lengthof sname
	call readstring
	mov name_len, eax

	mov edx, offset msg4
	call writestring
	mov edx, offset section
	mov ecx, lengthof section
	call readstring
	mov section_len, eax

	mov edx, offset msg5
	call writestring
	mov edx, offset marks
	mov ecx, lengthof marks
	call readstring
	mov marks_len, eax


	popad
	ret
take_input endp

combine_input Proc 
	pushad
	
	mov edi, 0

	mov ecx, roll_no_len
	mov esi, 0
	loop1:
		mov al , byte ptr [offset roll_no + esi]
		mov byte ptr [offset combined_str + edi], al
		inc edi
		inc esi
	loop loop1
	mov byte ptr [offset combined_str + edi], ','
	inc edi

	mov ecx, name_len
	mov esi, 0
	loop2:
		mov al , byte ptr [offset sname + esi]
		mov byte ptr [offset combined_str + edi], al
		inc edi
		inc esi
	loop loop2
	mov byte ptr [offset combined_str + edi], ','
	inc edi

	mov ecx, section_len
	mov esi, 0
	loop3:
		mov al , byte ptr [offset section + esi]
		mov byte ptr [offset combined_str + edi], al
		inc edi
		inc esi
	loop loop3
	mov byte ptr [offset combined_str + edi], ','
	inc edi

	mov ecx, marks_len
	mov esi, 0
	loop4:
		mov al , byte ptr [offset marks + esi]
		mov byte ptr [offset combined_str + edi], al
		inc edi
		inc esi
	loop loop4
	mov byte ptr [offset combined_str + edi], 0Ah
	inc edi
i
	mov combined_str_len, edi

	mov edx, offset combined_str
	call writestring
	
	popad
	ret
combine_input endp

append_data Proc
	pushad

	mov edx, offset data
	add edx, data_len
	mov esi, 0

	mov ecx, combined_str_len
	loop1:
		mov al, byte ptr [offset combined_str + esi]
		mov byte ptr [edx + esi], al
		inc esi
	loop loop1

	mov byte ptr [edx + esi], 0
	inc esi

	add data_len, esi

	mov edx, offset data
	call writestring

	popad
	ret
append_data endp

clear_arrays Proc
	pushad

	mov edx, offset roll_no
	mov ecx, lengthof roll_no
	mov esi , 0
	loop1:
		mov byte ptr [edx + esi], 0
		inc esi
	loop loop1
	mov roll_no_len, 0

	mov edx, offset sname
	mov ecx, lengthof sname
	mov esi , 0
	loop2:
		mov byte ptr [edx + esi], 0
		inc esi
	loop loop2
	mov name_len, 0

	mov edx, offset section
	mov ecx, lengthof section
	mov esi , 0
	loop3:
		mov byte ptr [edx + esi], 0
		inc esi
	loop loop3
	mov section_len, 0
	
	mov edx, offset marks
	mov ecx, lengthof marks
	mov esi , 0
	loop4:
		mov byte ptr [edx + esi], 0
		inc esi
	loop loop4
	mov marks_len, 0

	mov edx, offset combined_str
	mov ecx, lengthof combined_str
	mov esi , 0
	loop5:
		mov byte ptr [edx + esi], 0
		inc esi
	loop loop5
	mov combined_str_len, 0

	popad
	ret
clear_arrays endp

print_data Proc 
	pushad
	call clrscr

	mov dl, 10
	mov dh, 2
	call gotoXY
	mov edx, offset header1
	call writestring

	mov dl, 40
	mov dh, 2
	call gotoXY
	mov edx, offset header2
	call writestring

	mov dl, 70
	mov dh, 2
	call gotoXY
	mov edx, offset header3
	call writestring

	mov dl, 100
	mov dh, 2
	call gotoXY
	mov edx, offset header4
	call writestring

	mov ecx, total_elements
	mov esi, 0
	mov bh, 3
	outer_loop:

		mov dl, 10
		mov dh, bh
		call gotoXY
		mov eax, esi
		push ebx
		mov ebx, 10
		mul ebx
		pop ebx
		mov edx, offset roll_no_arr
		add edx, eax
		call writestring


		mov dl, 40
		mov dh, bh
		call gotoXY
		mov eax, esi
		push ebx
		mov ebx, 50
		mul ebx
		pop ebx
		mov edx, offset name_arr
		add edx, eax
		call writestring


		mov dl, 70
		mov dh, bh
		call gotoXY
		mov eax, esi
		push ebx
		mov ebx, 10
		mul ebx
		pop ebx
		mov edx, offset section_arr 
		add edx, eax
		call writestring

		mov dl, 100
		mov dh, bh
		call gotoXY
		mov eax, esi
		push ebx
		mov ebx, 10
		mul ebx
		pop ebx
		mov edx, offset marks_arr
		add edx, eax
		call writestring

		inc esi
		inc bh
		dec ecx
	cmp ecx, 0
	jne outer_loop
	


	mov dl, 0
	mov dh, 25
	call gotoXY


	popad
	ret
print_data endp

store_string_into_arrays Proc
	pushad

	mov esi, total_elements
	mov eax, esi
	mov ebx, 10
	mul ebx
	mov esi, eax
	mov edx, offset roll_no_arr
	add edx, esi 

	mov ecx, roll_no_len
	mov esi, 0
	loop1:
		mov al, byte ptr [offset roll_no + esi]
		mov byte ptr [ edx + esi ], al
		inc esi
	loop loop1


	mov esi, total_elements
	mov eax, esi
	mov ebx, 50
	mul ebx
	mov esi, eax
	mov edx, offset name_arr
	add edx, esi 

	mov ecx, name_len
	mov esi, 0
	loop2:
		mov al, byte ptr [offset sname + esi]
		mov byte ptr [ edx + esi ], al
		inc esi
	loop loop2


	mov esi, total_elements
	mov eax, esi
	mov ebx, 10
	mul ebx
	mov esi, eax
	mov edx, offset section_arr
	add edx, esi 

	mov ecx, section_len
	mov esi, 0
	loop3:
		mov al, byte ptr [offset section + esi]
		mov byte ptr [ edx + esi ], al
		inc esi
	loop loop3


	mov esi, total_elements
	mov eax, esi
	mov ebx, 10
	mul ebx
	mov esi, eax
	mov edx, offset marks_arr
	add edx, esi 

	mov ecx, marks_len
	mov esi, 0
	loop4:
		mov al, byte ptr [offset marks + esi]
		mov byte ptr [ edx + esi ], al
		inc esi
	loop loop4

	inc total_elements
	popad
	ret
store_string_into_arrays endp

store_data_into_strings Proc
	pushad

	mov edi, 0

	outer_loop:
		mov edx, offset data
		mov esi, 0
		mov ecx, 10
		label1:
			mov al, byte ptr [edx + edi]
			inc edi
			cmp al, ','
			je label1_out
			mov byte ptr [offset roll_no + esi], al
			inc esi
		loop label1
		label1_out:
		mov roll_no_len, esi
		

		mov esi, 0
		mov ecx, 50
		label2:
			mov al, byte ptr [edx + edi]
			inc edi
			cmp al, ','
			je label2_out
			mov byte ptr [offset sname + esi], al
			inc esi
		loop label2
		label2_out:
		mov name_len, esi
		

		mov esi, 0
		mov ecx, 10
		label3:
			mov al, byte ptr [edx + edi]
			inc edi
			cmp al, ','
			je label3_out
			mov byte ptr [offset section + esi], al
			inc esi
		loop label3
		label3_out:
		mov section_len, esi
		

		mov esi, 0
		mov ecx, 10
		label4:
			mov al, byte ptr [edx + edi]
			cmp al, 0ah
			je label4_out

			mov byte ptr [offset marks + esi], al
			inc esi
			inc edi

		loop label4
		label4_out:
		mov marks_len, esi
		
		call store_string_into_arrays

		inc edi
		inc edi

		mov edx, offset roll_no
		call writestring
		call crlf
		mov edx, offset sname
		call writestring
		call crlf

		mov edx, offset section
		call writestring
		call crlf

		mov edx, offset marks
		call writestring
		call crlf
		call crlf
		
		call clear_arrays
	cmp edi, data_len
	jl outer_loop
	popad
	ret
store_data_into_strings endp

swap_element Proc
	push ebp
	mov ebp, esp
	pushad
	mov esi, [ebp+8]
	mov edi, [ebp+12]

	mov eax, esi
	mov ebx, 50
	mul ebx
	mov edx, offset name_arr
	add edx, eax

	push edx
	mov eax, edi
	mov ebx, 50
	mul ebx
	mov ebx, offset name_arr
	add ebx, eax
	pop edx

	mov esi, 0
	loop1:
		mov al, byte ptr [edx + esi]
		mov cl, byte ptr [ebx + esi]
		push eax
		push ecx
		pop eax
		pop ecx
		mov byte ptr [edx + esi], al
		mov byte ptr [ebx + esi], cl

		inc esi
	cmp esi, 50
	jne loop1


	mov esi, [ebp+8]
	mov edi, [ebp+12]

	mov eax, esi
	mov ebx, 10
	mul ebx
	mov edx, offset roll_no_arr
	add edx, eax

	push edx
	mov eax, edi
	mov ebx, 10
	mul ebx
	mov ebx, offset roll_no_arr
	add ebx, eax
	pop edx

	mov esi, 0
	loop2:
		mov al, byte ptr [edx + esi]
		mov cl, byte ptr [ebx + esi]
		push eax
		push ecx
		pop eax
		pop ecx
		mov byte ptr [edx + esi], al
		mov byte ptr [ebx + esi], cl

		inc esi
	cmp esi, 10
	jne loop2



	mov esi, [ebp+8]
	mov edi, [ebp+12]

	mov eax, esi
	mov ebx, 10
	mul ebx
	mov edx, offset section_arr
	add edx, eax

	push edx
	mov eax, edi
	mov ebx, 10
	mul ebx
	mov ebx, offset section_arr
	add ebx, eax
	pop edx

	mov esi, 0
	loop3:
		mov al, byte ptr [edx + esi]
		mov cl, byte ptr [ebx + esi]
		push eax
		push ecx
		pop eax
		pop ecx
		mov byte ptr [edx + esi], al
		mov byte ptr [ebx + esi], cl

		inc esi
	cmp esi, 10
	jne loop3

	


	mov esi, [ebp+8]
	mov edi, [ebp+12]

	mov eax, esi
	mov ebx, 10
	mul ebx
	mov edx, offset marks_arr
	add edx, eax

	push edx
	mov eax, edi
	mov ebx, 10
	mul ebx
	mov ebx, offset marks_arr
	add ebx, eax
	pop edx

	mov esi, 0
	loop4:
		mov al, byte ptr [edx + esi]
		mov cl, byte ptr [ebx + esi]
		push eax
		push ecx
		pop eax
		pop ecx
		mov byte ptr [edx + esi], al
		mov byte ptr [ebx + esi], cl

		inc esi
	cmp esi, 10
	jne loop4


	popad
	pop ebp
	ret 8
swap_element endp

sort_by_name proc
	pushad
	mov eax, total_elements
	mov var, eax
	dec var

	mov esi, 0
	outer_loop:
		mov edi, esi
		inc edi
		inner_loop:
			mov eax, esi
			mov ebx, 50
			mul ebx
			mov edx, offset name_arr
			add edx, eax
			
			push edx
			mov eax, edi
			mov ebx, 50
			mul ebx
			mov ebx, offset name_arr
			add ebx, eax
			pop edx

			
			push ebx
			push edx
			call str_compare
			ja swap
			jmp no_swap
			swap:
				
				push edi
				push esi
				call swap_element
			no_swap:

			inc edi
		cmp edi, total_elements
		jb inner_loop
		
	inc esi
	cmp esi, var
	jb outer_loop

	popad
	ret
sort_by_name endp



sort_by_marks proc
	pushad
	mov eax, total_elements
	mov var, eax
	dec var

	mov esi, 0
	outer_loop:
		mov edi, esi
		inc edi
		inner_loop:
			mov eax, esi
			mov ebx, 10
			mul ebx
			mov edx, offset marks_arr
			add edx, eax
			call strLength
			mov var2, eax


			push edx
			mov eax, edi
			mov ebx, 10
			mul ebx
			mov ebx, offset marks_arr
			add ebx, eax
			mov edx, ebx
			call strLength
			pop edx

			cmp var2, eax
			jb swap
			ja no_swap
			
			push ebx
			push edx
			call str_compare
			jb swap
			jmp no_swap
			swap:
				
				push edi
				push esi
				call swap_element
			no_swap:

			inc edi
		cmp edi, total_elements
		jb inner_loop
		
	inc esi
	cmp esi, var
	jb outer_loop

	popad
	ret
sort_by_marks endp


main PROC
	

	
	main_loop:
		call clrscr
		mov edx, offset menue1
		call writestring
		call crlf
		mov edx, offset menue2
		call writestring
		call crlf
		mov edx, offset menue3
		call writestring
		call crlf
		mov edx, offset menue4
		call writestring
		call crlf
		mov edx, offset menue5
		call writestring
		call readchar
		call crlf

		cmp al , '1'
		je add_record
		cmp al, '2'
		je display_records
		cmp al, '3'
		je sort1
		cmp al, '4'
		je sort2
		cmp al, '5'
		jne main_loop
		jmp end_proc


		add_record:
			call read_from_file
			call take_input
			call combine_input
			call append_data
			call write_to_file
			jmp main_loop

		display_records:
			call read_from_file
			call store_data_into_strings
			call print_data
			call readchar
			jmp main_loop
		sort1:
			call read_from_file
			call store_data_into_strings
			call sort_by_name
			call print_data

			call readchar

			jmp main_loop

		sort2:
			call read_from_file
			call store_data_into_strings
			call sort_by_marks
			call print_data
			call readchar

			jmp main_loop


	
	
	end_proc:
exit	
main endp
end main