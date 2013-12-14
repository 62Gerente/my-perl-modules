# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl PrefixTree.t'

#########################

use strict;
use warnings;
use PrefixTree;
use Test::More tests => 47;

#PROF TESTS

my $dic = PrefixTree->new();

isa_ok($dic, 'PrefixTree');

my %tests = (
  'ab' => [qw{aba abaco abeto abrir aberto abertura}],
  'aba' => [qw{aba abaco}],
  'abe' => [qw{abeto aberto abertura}],
  'aber' => [qw{aberto abertura}],
  'ap' => [qw{aparecer aparece aparecida apurar apurado}],
  'apa' => [qw{aparecer aparece aparecida}],
  'aparec' => [qw{aparecer aparece aparecida}],
  'apu' => [qw{apurar apurado}],
  'apura' => [qw{apurar apurado}],
  'ac' => [],
  'ad' => [qw{adesao aderir}]
);

sub nub {
  my %seen = map {($_, 1)} @_;

  sort keys %seen;
}

my @words = nub map {@{$tests{$_}}} keys %tests;

$dic->add_word($_) for (@words);

ok(!$dic->get_words_with_prefix('xyz'), "non existing words");

for my $w (@words) {
  ok(grep {$_ eq $w} $dic->get_words_with_prefix($w), "checking for $w");
}

for my $p (keys %tests) {
  my @expected = sort @{$tests{$p}};
  my @obtained = sort $dic->get_words_with_prefix($p);
  is_deeply(\@expected, \@obtained, "checking for prefix $p");
}

$dic = PrefixTree->new();

my $palavra = "abracadabra";
my @palavras = map {substr $palavra, 0, $_} reverse 1..length($palavra);

for (@palavras) {
  ok(!$dic->get_words_with_prefix($_), "checking for non-existing word $_");
}

#MY TESTS

$dic->add_word($_) for (@words);
system("rm -f ~/ptree.save");

ok(
  !$dic->load("ptree.save"),
  "checking load with non-existing file"
);

ok(
  $dic->save("ptree.save"),
  "checking save"
);

ok(
  $dic->load("ptree.save"),
  "checking load with existing file"
);

ok(
  !$dic->rem_word("abril"),
  "checking remove word with non-existing word"
);

ok(
  $dic->rem_word("abrir"),
  "checking remove word with existing word"
);

ok(
  $dic->word_exists("apurado"),
  "checking word exists with existing word"
);

ok(
  !$dic->word_exists("apurados"),
  "checking word exists with non-existing word"
);

ok(
  !$dic->prefix_exists("apor"),
  "checking prefix exists with non-existing prefix"
);

ok(
  $dic->prefix_exists("apur"),
  "checking prefix exists with existing prefix"
);

$dic->add_word($_) for (@words);
$dic->save("ptree.save");
$dic->rem_word("abrir");
$dic->load("ptree.save");

ok(
  $dic->word_exists("abrir"),
  "checking if successfully recovers a previous state with load and save"
)

#########################
