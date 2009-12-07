# Show All Authors Plugin for Movable Type
# Author: Ben Boyd, beathan@gmail.com
package ShowAllAuthors::Plugin;

use MT;
use strict;

sub xfrm {

	my $plugin = shift;
	my ($cb, $app, $param, $tmpl) = @_;
	
	my $blog_id = $app->{'blog_id'};
	my $iter = MT::Author->load_iter(undef, {
		'join' => MT::Entry->join_on( 'author_id',
					{ blog_id => $blog_id },
					{ direction => 'descend',
					  unique => 1 }),
		'sort' => 'nickname'
	});
	
	my %seen;
	my @authors;
	while ( my $au = $iter->() ) {
		next if $seen{ $au->id };
		$seen{ $au->id } = 1;
		my @name = split(/(,|-)/, $au->nickname);
		my $row = {
			author_name => $name[0],
			author_id   => $au->id
		};
		push @authors, $row;
	}
	
	$param->{'context'}->{'__stash'}->{'vars'}->{'entry_author_loop'} = \@authors;

}

1;
