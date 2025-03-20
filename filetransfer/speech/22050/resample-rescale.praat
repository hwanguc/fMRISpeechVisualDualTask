# This script takes all the files in the specified directory, modify their scales to normalise the peak and 
# adjust the intensity to 70dB. Additionally, it resamples all files to 22050Hz
# It then writes new files to a new folder called "output", which it automatically creates. 
# The input directory is where the sound files are; the default option is where this script is.
# Hz = desired sampling rate
# samples = desired quality of interpolation. 1 = quick but poor quality, >1 = slower but higher quality
# Peak is your desired maximum amplitude. 
# db = desired average sound pressure level
#
# Dan Kennedy-Higgins
# 6/Feb/2015
# v 2.0

form Files
	sentence InputDir ./
	sentence outputDir ./output/
	positive Hz 22050
	positive samples 50
	positive Peak 0.99
	positive dB 70
endform

# Create an output directory

createDirectory ("output")

# this lists everything in the directory into a Strings list and counts how many there are

Create Strings as file list... list 'inputDir$'*.wav
numberOfFiles = Get number of strings

# then it loops through
for ifile to numberOfFiles

	# opens each file, one at a time

	select Strings list
	fileName$ = Get string... ifile
	Read from file... 'inputDir$''fileName$'

	# and scales peak and write to a new wav file	

	Scale peak... 'peak'
	Scale intensity... 'dB'
	Resample... 'Hz' 'samples'
	

	Write to WAV file... ./output/'fileName$'

	# then remove all the objects except the strings list so praat isn't all cluttered up

	select all
	minus Strings list
	Remove

endfor

# at the very end, remove any other objects sitting around - like the strings list

select all
Remove