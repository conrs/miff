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


def print_nice(x)
	x.each do |y|
		puts "\n"
		puts y.inspect
	end
end
def process_files(file1, file2)

	if(File.file?(file1) && File.file?(file2))

		file1  = File.open(file1, "r")
		file2 = File.open(file2, "r")
		while(!file1.eof? && !file2.eof?)
		
			line1 = file1.readline
			line2 = file2.readline
			
			if(line1 == line2)
				puts "equal"
			elsif
				linelcs = lcs(line1, line2)
				puts get_difference(linelcs, line1, line2)
			end
		end
 		
		if(!file1.eof?)
			file1.each {|l| puts ">> #{l}"}
		end
		if(!file2.eof?)
			file2.each {|l| puts "<< #{l}"}
		end	
	else
		puts get_difference(lcs(file1, file2), file1, file2)
	end
end


def get_difference(lcs1, line1, line2)
	#step through each letter synchronously 
	added = ""
	removed = ""
	puts "line1: #{line1} \nlcs: #{lcs1} \nline2: #{line2}"
	(0..lcs1.length).each do |i|
		if(line1[i] != lcs1[i] || line2[i] != lcs1[i])
			# aha, we differ here. 
			temp = i;
			
			while(line1[temp] != lcs1[i])
				removed.concat(line1[temp])
				temp = temp + 1
			end
			line1 = line1[0...i] + line1[temp..-1]	
			temp = i;
			
			while(line2[temp] != lcs1[i])
				added.concat(line2[temp])
				temp = temp + 1
			end
			line2 = line2[0...i] + line2[temp..-1]
		end
	end

	return "- " + removed + "\n+ " + added
end
		

# This is where LCS comes in. This function uses 
# the dynamic programming approach.

# returns: The longest common subsequence of the two lines 
def lcs(line1, line2)
	
	# heavily based on Domaratzki's notes - first find the LCS lengths 
	lengths = lcs_lengths(line1, line2)
	return walk_back(lengths, line1, line2)
end

def walk_back(lengths, line1, line2)
	i = lengths.size - 1
	j = lengths[i].size - 1
	ret = ""
	while i != 0 && j != 0
		if(lengths[i][j] == lengths[i][j-1])
			j = j - 1
		elsif(lengths[i][j] == lengths[i-1][j])
			i = i - 1
		else
			ret.concat(line1[i-1])
			j = j - 1
			
			i = i - 1
		end
	end
	
	return ret.reverse
end

=begin lcs_lengths:
	
	Constructs a 2x2 array where return[i][j] corresponds to the length of the LCS for line1[0..i] and line2[0..j]

=end
def lcs_lengths(line1, line2)
	ret = Array.new(line1.length + 1) {Array.new(line2.length + 1)}

	ret.map! {|x| x.map! {0}}
	(1..line1.length).each do |i|
		(1..line2.length).each do |j|
			if(line1[i-1] == line2[j-1])
				ret[i][j] = ret[i-1][j-1] + 1
			elsif(ret[i-1][j] >= ret[i][j-1])
				ret[i][j] = ret[i-1][j]
			else
				ret[i][j] = ret[i][j-1]			
			end	
		end
	end
	return ret
end
=begin	
	Character-based LCS's weren't proving great when outputting something meaningful. I have rewritten the algorithm
	slightly to handle word-based ones instead. 

	Note the pseudo-mind-blowing fact that all I have to do is split out the words, and then can use the exact same function
	as I did for the character-based lengths.
=end
def word_lcs_lengths(line1, line2)
	line1_words = line1.split(" ")
	line2_words = line2.split(" ")
	
	return lcs_lengths(line1_words, line2_words)
end 		
main
