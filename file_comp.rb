=begin
	file_comp:

	Goal: Take two files as input (via stdin), determine their differences. 
	
	Strategy:
		Step though each file, line-by-line. 
		Have some form of equality check to determine if they are equal.
		If they are not, determine where they differ via LCS.
=end 

# Load in our files. 

def main()
	if(ARGV.count == 2)
		file1 = ARGV[0]
		file2 = ARGV[1]  
		process_files(file1, file2)	
	else
		puts "please specify files..."
	end
end

def process_files(file1, file2)
	file1  = File.open(file1, "r")
	file2 = File.open(file2, "r")

	while(!file1.eof? && !file2.eof?)
		
		line1 = file1.readline
		line2 = file2.readline
		
		if(line1 <=> line2)
			puts "#{line1} #{line2}"
		end	
	end

	if(!file1.eof?)
		file1.each {|l| puts ">> #{l}"}
	end
	if(!file2.eof?)
		file2.each {|l| puts "<< #{l}"};
	end	
end



main	
