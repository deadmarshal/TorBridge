
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => 'Torbridge',
	      AUTHOR => 'Ali Moradi <adeadmarshal@gmail.com>',
	      VERSION_FROM => 'torbridge.pl',
	      LICENSE => 'gpl_3',
	      PREREQ_PM => {
			    'WWW::Mechanize' => '0',
			    'Moose' => '0',
			    'Mojolicious' => '0',
			    'LWP::Protocol::https' => '0',
			    'Term::ANSIColor' => '0'
			   },
	      TEST_REQUIRES => {
				'Test::More' => '0'
			       },
	      test => {TESTS => 't/*.t'},
	      EXE_FILES => [
			    'torbridge.pl'
			   ],
	      META_MERGE => {
			     'meta-spec' => {version => 0.02},
			     resources =>{
					  repository => {
							 type => 'git',
							 url => 'https://github.com/deadmarshal/TorBridge.git',
							},
					  bugtracker => {web => 'https://github.com/deadmarshal/TorBridge/issues'},
					 }
			    },
);
