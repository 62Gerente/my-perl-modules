package Abbreviation2Name;

use 5.016002;
use strict;
use warnings;
use Data::Dumper;
use utf8::all;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	&normalize &names &name
);

our $VERSION = '0.01';

sub new{
  my ($class, @filenames) = @_;
  
  my $self = {};
  bless $self, $class;
  $self->{names} = {};

  $self->add_dictionaries(@filenames);

  return $self;
}

sub add_dictionaries{
  my ($self, @filenames) = @_;
  my $file;

  for my$filename (@filenames){
    $file = $self->_open_file($filename);

    while (<$file>) {
      chomp;
      $self->add_name($_);    
    }  

    close($file);
  }
}

sub add_name{
  my ($self, $name) = @_;
  my $names = $self->{names};

  $names->{$name} = ();
}

sub names{
  my ($self, $name) = @_;
  my $names = $self->{names};

  return keys %$names;
}

sub normalize{
  my ($self, $abbrv) = @_;
  $_ = $abbrv;

  chomp;
  s/(.*)\s*\,\s*(.*)/$2 $1/ if (/(.*)\s*\,\s*(.*)/);
  s/([A-Z])(?=([A-Z]))/$1 /g if (/([A-Z])(?=([A-Z]))/);
  s/\./ /g;
  
  return split(/ /);
}

sub heuristics{
  my ($self, $abbrv) = @_;
  my $names = $self->{names};
  my %score; 

  my @parts = $self->normalize($abbrv);

  return %score unless (@parts);

  my $regex = ".*" . join(".*", @parts) . ".*";

  for my$cname (keys $names){
    $_ = $cname;
    
    if(/$regex/){
      $score{$cname} += 1;

      if(/^\s*$parts[0]/){
        $score{$cname} += 5;
      }else{
        $score{$cname} += 2 if(/^\s*\S*\s*$parts[0]/);
      }

      if(/\s$parts[$#parts]\s*$/){
        $score{$cname} += 5;
      }else{
        $score{$cname} += 2 if(/\s$parts[$#parts]\s*\S*\s*/);
      }

      if($#parts > 0){
        for (my $i = 1; $i < $#parts+1; $i++) {
          $_ = $cname;

          if(/$parts[$i-1]\S*\s+$parts[$i]/){
            $score{$cname} += 2;
            last;
          }
        }
      }
    }
  }

  return %score;
}

sub name{
  my ($self, $abbrv)  = @_;
  my %heuristics = $self->heuristics($abbrv);

  my @names = sort {$heuristics{$b} <=> $heuristics{$a}} keys %heuristics;

  my $name;
  if (@names){
    $name = $names[0];
  }else{
    $name = undef;
  }

  return $name;
}

sub _open_file{
  my ($self, $filename) = @_;
  my $file;

  given($filename){
    when (/\.bz2$/) {open $file, "bzcat $filename | " or die "Can't open $filename with bzcat: $!";}
    when (/\.gz2$/) {open $file, "zcat $filename | " or die "Can't open $filename with zcat: $!";}
    default         {open $file, "<", $filename or die "Can't open $filename for reading: $!";}
  }

  return $file;
}


1;
__END__
=head1 NAME

Abbreviation2Name - Perl extension for translating abbreviations into full names.

=head1 SYNOPSIS

  use Abbreviation2Name;

=head1 AUTHOR

André Santos, E<lt>andreccdr@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by André Santos

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
