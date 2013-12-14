# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Abbreviation2Name.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use Data::Dumper;
use utf8::all;

use Test::More tests => 12;
BEGIN { use_ok('Abbreviation2Name') };

my $dic = Abbreviation2Name->new();

isa_ok($dic, 'Abbreviation2Name');

ok(length $dic->names, "Testing that the list of names starts empty.");

$dic->add_dictionaries("files/di.names");

ok(length $dic->names, "Testing that the list of names isnt's empty after 'add_dictionaries'.");

my %abbrvs;
$abbrvs{"ANR"} = "António Manuel Nestor Ribeiro";
$abbrvs{"Creissac Campos, José"} = "José Francisco Creissac Freitas Campos";
$abbrvs{"Belo"} = "Orlando Manuel de Oliveira Belo";
$abbrvs{"Bernardo B., José"} = "José Bernardo dos Santos Monteiro Vieira de Barros";
$abbrvs{"JBB"} = "José Bernardo dos Santos Monteiro Vieira de Barros";
$abbrvs{"J.J."} = "José João Antunes Guimarães Dias de Almeida";
$abbrvs{"JJ"} = "José João Antunes Guimarães Dias de Almeida";
$abbrvs{"Bacelar"} = "José Carlos Bacelar Ferreira Junqueira de Almeida";

for my$key (keys %abbrvs){
  ok($dic->name($key) eq $abbrvs{$key}, "Testing abbreviation of $key");
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

