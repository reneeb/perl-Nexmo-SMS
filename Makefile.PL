use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Nexmo::SMS',
    AUTHOR              => q{Renee Baecker <module@renee-baecker.de>},
    VERSION_FROM        => 'lib/Nexmo/SMS.pm',
    ABSTRACT_FROM       => 'lib/Nexmo/SMS.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'artistic_2')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Nexmo-SMS-*' },
);
