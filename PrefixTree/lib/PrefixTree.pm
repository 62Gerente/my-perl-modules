package PrefixTree;

use 5.016002;
use strict;
use warnings;
use feature qw(say switch);
use Storable qw(store retrieve);

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	&new &add_dict &add_word &rem_word &save &load &prefix_exists &word_exists
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

# PUBLIC METHODS

sub new{
  my ($class, @filenames) = @_;
  
  my $self = {};
  bless $self, $class;
  $self->{prefixtree} = {};

  $self->add_dict(@filenames);

  return $self;
}

sub save{
  my ($self, $filename) = @_;
  store($self->{prefixtree}, "$ENV{HOME}/$filename") or die "Can't store %a in home directory!\n";
  return 1;
}

sub load{
  my ($self, $filename) = @_;
  my $load_words;

  eval{
    $load_words = retrieve("$ENV{HOME}/$filename");
  };

  if(defined $load_words){
    $self->{prefixtree} = $load_words;
    return 1;
  }else{
    return 0;
  }
}

sub add_dict{
  my ($self, @filenames) = @_;
  my $file;

  for my$filename (@filenames){
    $file = $self->_open_file($filename);

    while (<$file>) {
      chomp;
      my @words = split;
      $self->add_word($_) for @words;    
    }  
  }
}

sub add_word{
  my ($self, $word) = @_;
  my $tree = $self->{prefixtree};
  my @letters = split('',$word);

  while (@letters && exists($tree->{$letters[0]})){
    $tree = $tree->{shift(@letters)};
  }

  for my$letter (@letters) {
    $tree = $tree->{$letter} = {};
  }

  $tree->{_E} = 1;
}

sub rem_word{
  my($self, $word) = @_;
  my $tree = $self->{prefixtree};

  $tree = $self->_last_node($word);

  if (exists $tree->{_E} and $tree->{_E}==1){
    $tree->{_E} = 0;
    return 1;
  }else{
    return 0;
  }
}

sub get_words_with_prefix{
  my ($self, $prefix) = @_;
  my $tree = $self->{prefixtree};
  my @letters = split('',$prefix);
  my @retarray = ();
  my $letter = '';

  while(defined($letter = shift(@letters))) {
    unless (exists $tree->{$letter}) {
      return ();
    }
    $tree = $tree->{$letter};
  }

  @retarray = $self->_walktree(
      word => $prefix,
      tree => $tree
  );
  
  return @retarray;
}

sub prefix_exists{
  my ($self, $prefix) = @_;
  my $tree = $self->{prefixtree};
  my @letters = split('',$prefix);
  my $letter = '';

  while(defined($letter = shift(@letters))) {
    unless (exists $tree->{$letter}) {
      return 0;
    }
    $tree = $tree->{$letter};
  }

  return 1;
}

sub word_exists{
  my($self, $word) = @_;
  my @letters = split('',$word);
  my $tree = $self->{prefixtree};

  $tree = $self->_last_node($word);

  if (exists $tree->{_E} and $tree->{_E}==1){
    return 1;
  }else{
    return 0;
  }
}

# PRIVATE METHODS

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

sub _last_node{
  my($self, $word) = @_;
  my $tree = $self->{prefixtree};
  my @letters = split('',$word);
  
  for my $letter (@letters) {
    if ($tree->{$letter}) {
      $tree = $tree->{$letter};
    }else {
      $tree = {};
      last;
    }
  }

  return $tree;
}

sub _walktree{
  my ($self, %args) = @_;
  my $word = $args{word};
  my $tree = $args{tree};
  my @retarray = ();

  for my$key (keys %{$tree}) {
    if ($key eq '_E' and $tree->{_E}==1){
      push(@retarray,$word);
      next;
    }

    my $nextval =  $word . $key;

    my %arguments = (
        word => $nextval,
        tree => $tree->{$key});

    push(@retarray, $self->_walktree(%arguments));
  }

  return @retarray;
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

PrefixTree - A data structure optimized for prefix lookup.

=head1 SYNOPSIS

  use PrefixTree;

=head1 AUTHOR

André Santos, andreccdr@gmail.com<

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by André Santos

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
