
our @files;

use FindBin;

BEGIN { @files = glob "$FindBin::Bin/yui/*.css" }

use Test::Differences;
use Test::More
    tests => 1 + @files;

BEGIN {
    use_ok( 'CSS::Compressor' => qw( compress ) );
}

diag "yui test files: @files\n";

for my $file ( @files ) {
    die "$!: $file.min"
        unless open my $fh => '<' => $file;
    my $source = do { local $/; <$fh> };
    close $fh;

    die "$!: $file.min"
        unless open $fh => '<' => $file.'.min';
    my $target = do { local $/; <$fh> };
    close $fh;

    my $result = compress( $source );

    # make diffs readable
    s!([{;])!$1\n!smg,
    s!([}])!\n$1!smg
        for $result, $target;

    eq_or_diff $result => $target => "$file == $file.min";
}
