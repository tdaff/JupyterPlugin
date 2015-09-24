package Foswiki::Plugins::JupyterPlugin;
use strict;

use File::Temp qw(tempfile);
use IO::Handle;

our $VERSION           = '0.1';
our $RELEASE           = '0.1';
our $SHORTDESCRIPTION  = 'Plugin that renders Jupyter Notebooks as inline HTML through nbconvert';
our $NO_PREFS_IN_TOPIC = 0;
our $pluginName        = 'JupyterPlugin';

my $nbconvert = $Foswiki::cfg{Plugins}{JupyterPlugin}{NbconvertPath};

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    Foswiki::Func::registerTagHandler( 'JUPYTER', \&_JUPYTER );

    return 1;
}

sub _JUPYTER {
    my ( $session, $params, $theTopic, $theWeb ) = @_;

    my $nbName = $params->{_DEFAULT} || '';

    #my $yotherparam = $params->{otherparam} || '';

    Foswiki::Func::attachmentExists( $theWeb, $theTopic, $nbName )
      || return 'Notebook not found ' . $nbName;

    # Read in the contents of the notebook into a string
    # Foswiki says not to access files directly!
    my $data = Foswiki::Func::readAttachment( $theWeb, $theTopic, $nbName );

    my $workArea = Foswiki::Func::getWorkArea('JupyterPlugin');
    my ( $fh, $filename ) = tempfile( DIR => $workArea, SUFFIX => '.ipynb', UNLINK => 1 );
    print $fh $data;
    $fh->flush();

    my $outText = '';
    my $inImage = 0;

    my $converted = '<noautolink>' . `$nbconvert --to html --stdout $filename` . '</noautolink>';

    for ( split /^/, $converted ) {
        if ( $_ =~ /base64/ ) {
            $inImage = 1;
        }
        if ($inImage) {
            chomp;
            if ( $_ =~ />/ ) {
                $inImage = 0;
            }
        }
        $outText .= $_;
    }

    close $fh;

    return $outText;
}
