#!/usr/bin/perl

use strict;
use warnings;

use Template;

my $tt = Template->new({
    INTERPOLATE  => 1,
})
    or die "$Template::ERROR\n";

sub embed_sample_generic
{
    my ($sample_id) = @_;

    my $text;
    {
        open my $in, "<", "samples/$sample_id"
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

sub embed_sample
{
    my $sample = shift;

    return embed_sample_generic("$sample.html");
}

sub embed_xhtml_sample
{
    my $sample = shift;

    return embed_sample_generic("$sample.xhtml");
}

sub start_tag
{
    my $id = shift;

    return qq{<code xml:lang="en">&lt;$id&gt;</code>};
}

sub end_tag
{
    my $id = shift;
    return start_tag("/$id");
}

sub standalone_tag
{
    my $id = shift;
    return start_tag("$id /");
}

my $vars =
{
    embed_sample => \&embed_sample,
    embed_xhtml_sample => \&embed_xhtml_sample,
    stag => \&start_tag,
    etag => \&end_tag,
    # Only tag.
    otag => \&standalone_tag,
};

$tt->process(
    "hebrew-html-tutorial.xml.tt",
    $vars,
    "hebrew-html-tutorial.xml",
)
    or die $tt->error(), "\n";
