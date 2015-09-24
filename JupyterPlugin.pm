package Foswiki::Plugins::JupyterPlugin;
use strict;

use File::Temp qw(tempfile)
use IO::Handle;

our $VERSION = '0.1';
our $RELEASE = '0.1';
our $SHORTDESCRIPTION = 'Plugin that renders Jupyter Notebooks through nbconvert';
our $NO_PREFS_IN_TOPIC = 0;
our $pluginName = 'JupyterPlugin';

my $jupyter = '/usr/bin/jupyter'

sub initPlugin {
    my( $topic, $web, $user, $installWeb ) = @_;

    Foswiki::Func::registerTagHandler( 'JUPYTER', \&_JUPYTER );

    return 1;
}

sub _JUPYTER {
    my($session, $params, $theTopic, $theWeb) = @_;

    my $nbName = $params->{_DEFAULT} || '';
    #my $yotherparam = $params->{otherparam} || '';

    Foswiki::Func::attachmentExists( $theWeb, $theTopic, $nbName ) || return 'Notebook not found '.$nbName;

    # Read in the contents of the 
    my $data = Foswiki::Func::readAttachment( $web, $topic, $a->{name} );

    my $workArea = Foswiki::Func::getWorkArea('JupyterPlugin');
    ($fh, $filename) = tempfile(DIR => $workArea, SUFFIX => '.ipynb');
    print $fh $data;
    $fh->flush();
    my $text = `$jupyter nbconvert --to html --stdout $filename`;
    close $fh;
    return $text;
}
