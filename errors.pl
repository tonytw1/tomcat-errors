use strict;
use HTML::Entities;

sub findErrors {
    my $logfile = shift;
    my @errors = ( $logfile =~ /(ERROR.*?)\n\d\d [A-Z][a-z][a-z] \d\d\d\d/gs );
    return @errors;
}

my $log = join('', <STDIN>);

my @errors = findErrors($log);
#print 'Found errors: ' + @errors+0 + "\n\n";

my %errorCounts;
foreach my $error (@errors) {
    my $count = %errorCounts->{$error};
    if (!$count) {
	$count =0;
    }
    $count++;
    %errorCounts->{$error} = $count;
}

print '
<html>
<head><link rel="stylesheet" href="styles.css"></head>
<body>
<table>
';

foreach my $error (sort {$errorCounts{$b} <=> $errorCounts{$a} } keys %errorCounts) {
    print '<tr valign="top">';
    print '<td class="count">';
    print $errorCounts{$error};
    print '</td><td class="error"><pre>';
    print encode_entities($error);
    print '</pre></td>';
    print '</tr>';
}

print '</table>';
