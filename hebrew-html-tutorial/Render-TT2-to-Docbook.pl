#!/usr/bin/perl

use strict;
use warnings;

use Template;

my $tt = Template->new({
    INTERPOLATE  => 1,
}) 
    or die "$Template::ERROR\n";

sub embed_sample
{
    my ($sample_id) = @_;

    my $text;
    {
        open my $in, "<", "samples/$sample_id.html"
            or die "Could not open $sample_id in embed_sample()";
        
        local $/;
        $text = <$in>;
        close($in);
    }

    return <<"EOF"
<programlisting xml:lang="en">
<![CDATA[
$text
]]>
</programlisting>

EOF
}

my $vars =
{
    embed_sample => \&embed_sample,
};

$tt->process(
    "hebrew-html-tutorial.xml.tt",
    $vars, 
    "hebrew-html-tutorial.xml",
)
    or die $tt->error(), "\n";
