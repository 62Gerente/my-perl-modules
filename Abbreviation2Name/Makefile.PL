use 5.016002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Abbreviation2Name',
    VERSION_FROM      => 'lib/Abbreviation2Name.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Abbreviation2Name.pm', # retrieve abstract from module
       AUTHOR         => 'André Santos <andreccdr@gmail.com>') : ()),
    EXE_FILES         => ['bin/abbrv2name']  
);
