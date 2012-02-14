package Net::Flowdock;
{
  $Net::Flowdock::VERSION = '0.01';
}
use Moose;

# ABSTRACT: Flowdock API

use Net::HTTP::Spore;


has '_client' => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        
        my $client = Net::HTTP::Spore->new_from_string(
            '{
                "name": "Flowdock",
                "authority": "GITHUB:gphat",
                "version": "1.0",
                "methods": {
                    "post": {
                        "path": "/v1/messages/influx/:key",
                        "required_params": [
                            "source", "from_address", "subject", "content"
                        ],
                        "optional_params": [
                            "from_name", "project", "format", "tags", "link"
                        ],
                        "method": "POST"
                    }
                }
            }',
            base_url => $self->url,
            trace => $self->debug
        );
        return $client
    }
);


has 'debug' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);


has 'key' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);


has 'url' => (
    is => 'rw',
    isa => 'Str',
    default => 'https://api.flowdock.com'
);


sub send {
    my $self = shift;
    my $args = shift;
    
    return $self->_client->post(
        key => $self->key,
        source => $args->{source},
        from_address => $args->{from_address},
        from_name => $args->{from_name},
        subject => $args->{subject},
        content => $args->{content},
        project => $args->{project},
        format => $args->{format},
        tags => $args->{tags},
        link => $args->{link}
    );
}

1;

__END__
=pod

=head1 NAME

Net::Flowdock - Flowdock API

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    use Net::Flowdock;

    my $client = Net::Flowdock->new(key => 'find-your-own');

    $client->send({
        source => 'CPAN',
        from_address => 'gphat@cpan.org',
        from_name => 'Cory Watson',
        subject => 'Uploaded Net::Flowdock',
        content => "Sho' nuff",
        project => 'Open Source',
        tags => 'wow,yeah,poop',
        link => 'http://search.cpan.org'
    });

=head1 DESCRIPTION

Net::Flowdock is a simple client for using the L<Flowdock API|https://www.flowdock.com/help/api_documentation>.

=head1 ATTRIBUTES

=head2 debug

Set/Get the debug flag.

=head2 key

Set/Get the key to use when connecting to Flowdock.

To obtain the API Token go to Settings -> Team Inbox inside a flow. 

=head2 url

Set/Get the URL for Flowdock. Defaults to https://api.flowdock.com.

=head1 METHODS

=head2 send ({ source => $source, from_address => $email })

Required fields:

=over 4

=item source

Human readable identifier of the application that uses the Flowdock API. Only alphanumeric characters, underscores and whitespace can be used. This identifier will be used as the primary method of categorization for the messages. 

Example value: Awesome Issue Management App

=item from_address

Email address of the message sender. The email address is used to show a avatar of the sender. You can customize the avatar by registering the address in

Example value: john.doe@yourdomain.com

=item subject

Subject line of the message, will be displayed as the title of Team Inbox message.

=item content

Content of the message, will be displayed as the body of Team Inbox message. 

Following HTML tags can be used: a abbr acronym address article aside b big blockquote br caption cite code dd del details dfn div dl dt em figcaption figure footer h1 h2 h3 h4 h5 h6 header hgroup hr i img ins kbd li nav ol p pre samp section small span strong sub summary sup table tbody td tfoot th thead tr tt ul var wb

=back

Optional fields:

=over 4

=item from_name

Name of the message sender.

Example value: John Doe

=item project

Human readable identifier for more detailed message categorization. Only alphanumeric characters, underscores and whitespace can be used. This identifier will be used as the secondary method of categorization for the messages.

Example value: My Project

=item format

Format of the message content, default value is "html". Only HTML is currently supported. 

Example value: html

=item tags

Tags of the message, separated by commas.

Example value: cool,stuff

=item link

Link associated with the message. This will be used to link the message subject in Team Inbox.

Example value: http://www.flowdock.com/

=back

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

