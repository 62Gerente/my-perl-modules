use 5.016002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'PrefixTree',
    VERSION_FROM      => 'lib/PrefixTree.pm', # finds $VERSION
    PREREQ_PM         => {feature => 0, Storable => 0}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/PrefixTree.pm', # retrieve abstract from module
       AUTHOR         => 'André Santos <andreccdr@gmail') : ()),
);
