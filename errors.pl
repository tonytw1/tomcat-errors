use strict;
use HTML::Entities;

sub findErrorLines {
    my $logfile = shift;
    my @errors = ( $logfile =~ /(\d\d [A-Z][a-z][a-z] \d\d\d\d \d\d:\d\d:\d\d,\d\d\d ERROR.*?)\n\d\d [A-Z][a-z][a-z] \d\d\d\d/gs );
    return @errors;
}

my $log = join('', <STDIN>);

my @errorLines = findErrorLines($log);
#print 'Found errors: ' + @errors+0 + "\n\n";

my $firstDate;
my $lastDate;

my %errorCounts;
foreach my $errorLine (@errorLines) {    
    my $error = $errorLine;
    $error =~ s/\d\d [A-Z][a-z][a-z] \d\d\d\d \d\d:\d\d:\d\d,\d\d\d //;

    my $dateString = $errorLine;
    $dateString =~ s/^(.*?) ERROR.*/$1/gs;
    if (!$firstDate) {
	$firstDate = $dateString;
    }
    $lastDate = $dateString;

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
';

print "<p>Live errors from $firstDate to $lastDate</p>";
print '<table>
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
print '</body></html>';

1;

