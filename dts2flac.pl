#!/usr/bin/perl

# dts2flac: Script to bulk-convert dts audio files to multichannel FLAC
# Copyright (C) 2015 Oliver Götz
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

my $file_pattern=$ARGV[0];
my @files = <"$file_pattern">;
my $tsmeta_file = "./tsmeta";
my $tsmuxer = "c:/Tools/tsMuxer/tsMuxeR.exe";
my $eac3to = "C:/Tools/eac3to327/eac3to.exe";

foreach my $file (@files) {
	print $file, "\n";
	
	# Create tmp meta file for muxer
	open (METAFILE, '>'.$tsmeta_file); 
	print METAFILE "MUXOPT --no-pcr-on-video-pid --new-audio-pes --vbr  --vbv-len=500\n"; 
	print METAFILE "A_DTS, \"$file\"\n";
	close (METAFILE);

	# ts Output file name
	my $ts_filename = $file;
	$ts_filename =~ s/\.dts$/\.ts/i;
	print $file, " -> ", $ts_filename, "\n";
	
	# start muxer
	my $tsmuxer_command = "$tsmuxer $tsmeta_file \"$ts_filename\"";
	print $tsmuxer_command, "\n";
	system($tsmuxer_command);
	
	# delete tmp meta file
	unlink $tsmeta_file;
	
	# flac Output file name
	my $flac_filename = $file;
	$flac_filename =~ s/\.dts$/\.flac/i;
	print $file, " -> ", $flac_filename, "\n";

	# start eac3to
	my $eac3to_command = "$eac3to \"$ts_filename\" \"$flac_filename\"";
	print $eac3to_command, "\n";
	system($eac3to_command);
	
	# delete muxer (ts) file
	unlink $ts_filename;
	
	print "-------------------------------------------------------------\n\n";
}


