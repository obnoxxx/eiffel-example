-- small example application in Eiffel
-- just for practice and illustration purposes.

class
	APPLICATION -- the root class
inherit
	ARGUMENTS
	EXCEPTIONS

create
	make
feature {NONE} -- application class: everything is private.
	name: STRING

feature {NONE} -- print help text
	print_help
do
		print(" USAGE: %N")
		print(" application options .. %N")
		print(" available options:%N")
		print(" -n Name	caller's name - REQUIRED%N")
		print(" -h	print this help text%N")
end
feature {NONE} -- Initialization
	make
do
		name := ""
		-- Parse arguments:
		if attached separate_character_option_value('h')as l_val and then not  l_val.is_empty then
				print ("invocation error: -h does not take an argument.%N")
				print_help
				die(1)
		elseif attached separate_character_option_value('h') as l_val and then l_val.is_empty then
				print_help
				die(0)
		end
		if attached separate_character_option_value('n') as l_val and then not l_val.is_empty then
			name := l_val
		else
			print("invocation error: -n NAME is required.%N")
			print_help
			die (1)
		end
			-- normal action:
			print ("Hello, " + name + "!%N")
end
end
