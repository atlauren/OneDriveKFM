BEGIN {
print "\042BEFORE\042,\042AFTER\042"
}
{
# if not line ending ' append ' to end of line
if (!/\x27$/)
	{ sub(/$/,"\047")
	}
# add ' to end of "mv -- /"
if (/^mv -- \//)
	{sub(/\//,"\047\/")
	}
# add ' before " " of " /Users"
if (/ \/Users/ && !/\x27 \/Users/)
	{ sub(/ \/Users/,"\047 \/Users")
	}
# add 'before "/" of " /Users"
if (/ \/Users/)
	{ sub(/ \/Users/," \047\/Users")
	}
# trim "mv -- " from start of lines
sub (/^mv -- /,"")
# change ' ' to ','
sub(/\x27 \x27/,"\047,\047")
# replace all " with ""
gsub(/\x22/,"\042\042")
# replace all ' with "
gsub (/\x27/,"\042")
print $0
}