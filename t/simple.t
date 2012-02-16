
use Test::More
    tests => 2;

BEGIN {
    use_ok('CSS::Compressor' => qw( compress ) );
}

my $result = compress(<<CSS);
some foo {
    color: red; /* with comments */
}
CSS

is $result => 'some foo{color:red}' => 'match';

