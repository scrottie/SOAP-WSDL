package MyInterfaces::RunningServiceClass::RunningServiceClassSoap;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use Scalar::Util qw(blessed);
use base qw(SOAP::WSDL::Client::Base);

# only load if it hasn't been loaded before
require MyTypemaps::RunningServiceClass
    if not MyTypemaps::RunningServiceClass->can('get_class');

sub START {
    $_[0]->set_proxy('https://sp-01.erlm.siemens.de/sites/CUP1/ITIL/_vti_bin/ITIL/RunningService.asmx') if not $_[2]->{proxy};
    $_[0]->set_class_resolver('MyTypemaps::RunningServiceClass')
        if not $_[2]->{class_resolver};

    $_[0]->set_prefix($_[2]->{use_prefix}) if exists $_[2]->{use_prefix};
}

sub AddTask {
    my ($self, $body, $header) = @_;
    die "AddTask must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'AddTask',
        soap_action => 'http://tempuri2.org/AddTask',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::AddTask )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub ModifyTask {
    my ($self, $body, $header) = @_;
    die "ModifyTask must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'ModifyTask',
        soap_action => 'http://tempuri2.org/ModifyTask',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::ModifyTask )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub CreateGroup {
    my ($self, $body, $header) = @_;
    die "CreateGroup must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'CreateGroup',
        soap_action => 'http://tempuri2.org/CreateGroup',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::CreateGroup )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub AddUsersToGroup {
    my ($self, $body, $header) = @_;
    die "AddUsersToGroup must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'AddUsersToGroup',
        soap_action => 'http://tempuri2.org/AddUsersToGroup',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::AddUsersToGroup )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub RemoveUsersFromGroup {
    my ($self, $body, $header) = @_;
    die "RemoveUsersFromGroup must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'RemoveUsersFromGroup',
        soap_action => 'http://tempuri2.org/RemoveUsersFromGroup',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::RemoveUsersFromGroup )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub ClearGroup {
    my ($self, $body, $header) = @_;
    die "ClearGroup must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'ClearGroup',
        soap_action => 'http://tempuri2.org/ClearGroup',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::ClearGroup )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub DeleteGroup {
    my ($self, $body, $header) = @_;
    die "DeleteGroup must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'DeleteGroup',
        soap_action => 'http://tempuri2.org/DeleteGroup',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::DeleteGroup )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub AddCalendarEntry {
    my ($self, $body, $header) = @_;
    die "AddCalendarEntry must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'AddCalendarEntry',
        soap_action => 'http://tempuri2.org/AddCalendarEntry',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::AddCalendarEntry )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub ModifyCalendarEntry {
    my ($self, $body, $header) = @_;
    die "ModifyCalendarEntry must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'ModifyCalendarEntry',
        soap_action => 'http://tempuri2.org/ModifyCalendarEntry',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::ModifyCalendarEntry )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub AddAttachment {
    my ($self, $body, $header) = @_;
    die "AddAttachment must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'AddAttachment',
        soap_action => 'http://tempuri2.org/AddAttachment',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::AddAttachment )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub GetAttachment {
    my ($self, $body, $header) = @_;
    die "GetAttachment must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'GetAttachment',
        soap_action => 'http://tempuri2.org/GetAttachment',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::GetAttachment )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub GetItems {
    my ($self, $body, $header) = @_;
    die "GetItems must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'GetItems',
        soap_action => 'http://tempuri2.org/GetItems',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::GetItems )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub GetItemVersions {
    my ($self, $body, $header) = @_;
    die "GetItemVersions must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'GetItemVersions',
        soap_action => 'http://tempuri2.org/GetItemVersions',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::GetItemVersions )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub CountItems {
    my ($self, $body, $header) = @_;
    die "CountItems must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'CountItems',
        soap_action => 'http://tempuri2.org/CountItems',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::CountItems )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub DeleteItem {
    my ($self, $body, $header) = @_;
    die "DeleteItem must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'DeleteItem',
        soap_action => 'http://tempuri2.org/DeleteItem',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::DeleteItem )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}




1;



__END__

=pod

=head1 NAME

MyInterfaces::RunningServiceClass::RunningServiceClassSoap - SOAP Interface for the RunningServiceClass Web Service

=head1 SYNOPSIS

 use MyInterfaces::RunningServiceClass::RunningServiceClassSoap;
 my $interface = MyInterfaces::RunningServiceClass::RunningServiceClassSoap->new();

 my $response;
 $response = $interface->AddTask();
 $response = $interface->ModifyTask();
 $response = $interface->CreateGroup();
 $response = $interface->AddUsersToGroup();
 $response = $interface->RemoveUsersFromGroup();
 $response = $interface->ClearGroup();
 $response = $interface->DeleteGroup();
 $response = $interface->AddCalendarEntry();
 $response = $interface->ModifyCalendarEntry();
 $response = $interface->AddAttachment();
 $response = $interface->GetAttachment();
 $response = $interface->GetItems();
 $response = $interface->GetItemVersions();
 $response = $interface->CountItems();
 $response = $interface->DeleteItem();



=head1 DESCRIPTION

SOAP Interface for the RunningServiceClass web service
located at https://sp-01.erlm.siemens.de/sites/CUP1/ITIL/_vti_bin/ITIL/RunningService.asmx.

=head1 SERVICE RunningServiceClass



=head2 Port RunningServiceClassSoap



=head1 METHODS

=head2 General methods

=head3 new

Constructor.

All arguments are forwarded to L<SOAP::WSDL::Client|SOAP::WSDL::Client>.

=head2 SOAP Service methods

Method synopsis is displayed with hash refs as parameters.

The commented class names in the method's parameters denote that objects
of the corresponding class can be passed instead of the marked hash ref.

You may pass any combination of objects, hash and list refs to these
methods, as long as you meet the structure.

List items (i.e. multiple occurences) are not displayed in the synopsis.
You may generally pass a list ref of hash refs (or objects) instead of a hash
ref - this may result in invalid XML if used improperly, though. Note that
SOAP::WSDL always expects list references at maximum depth position.

XML attributes are not displayed in this synopsis and cannot be set using
hash refs. See the respective class' documentation for additional information.



=head3 AddTask

This method is used to create a Task item within the task list. Values will be set if they are not null.

Returns a L<MyElements::AddTaskResponse|MyElements::AddTaskResponse> object.

 $response = $interface->AddTask( {
    taskListName =>  $some_value, # string
    createData =>  { # MyTypes::ItemCreateData
      Folder =>  { # MyTypes::Folders
        SubFolder =>  $some_value, # string
      },
      Author =>  { value => $some_value },
      GroupID =>  $some_value, # int
    },
    modifyData =>  { # MyTypes::TaskModifyData
      Status =>  $some_value, # string
      Description =>  $some_value, # string
      DueDate =>  $some_value, # dateTime
      AssignedTo =>  { value => $some_value },
    },
  },,
 );

=head3 ModifyTask

Modifies an existing task. Values are only set if they are not null.

Returns a L<MyElements::ModifyTaskResponse|MyElements::ModifyTaskResponse> object.

 $response = $interface->ModifyTask( {
    taskListName =>  $some_value, # string
    id =>  $some_value, # int
    User =>  { value => $some_value },
    modifyData =>  { # MyTypes::TaskModifyData
      Status =>  $some_value, # string
      Description =>  $some_value, # string
      DueDate =>  $some_value, # dateTime
      AssignedTo =>  { value => $some_value },
    },
  },,
 );

=head3 CreateGroup

Creates a group within the web.

Returns a L<MyElements::CreateGroupResponse|MyElements::CreateGroupResponse> object.

 $response = $interface->CreateGroup( {
    groupName =>  $some_value, # string
    description =>  $some_value, # string
  },,
 );

=head3 AddUsersToGroup

Adds a set of users to the given group.

Returns a L<MyElements::AddUsersToGroupResponse|MyElements::AddUsersToGroupResponse> object.

 $response = $interface->AddUsersToGroup( {
    groupName =>  $some_value, # string
    userMails =>  { # MyTypes::ArrayOfNUser
      NUser =>  { value => $some_value },
    },
  },,
 );

=head3 RemoveUsersFromGroup

Removes a user from a given group.

Returns a L<MyElements::RemoveUsersFromGroupResponse|MyElements::RemoveUsersFromGroupResponse> object.

 $response = $interface->RemoveUsersFromGroup( {
    groupName =>  $some_value, # string
    userMails =>  { # MyTypes::ArrayOfNUser
      NUser =>  { value => $some_value },
    },
  },,
 );

=head3 ClearGroup

Removes all users from the given group.

Returns a L<MyElements::ClearGroupResponse|MyElements::ClearGroupResponse> object.

 $response = $interface->ClearGroup( {
    groupName =>  $some_value, # string
  },,
 );

=head3 DeleteGroup

Deletes a group from the web.

Returns a L<MyElements::DeleteGroupResponse|MyElements::DeleteGroupResponse> object.

 $response = $interface->DeleteGroup( {
    groupName =>  $some_value, # string
  },,
 );

=head3 AddCalendarEntry

Builds a new entry for the calendar.

Returns a L<MyElements::AddCalendarEntryResponse|MyElements::AddCalendarEntryResponse> object.

 $response = $interface->AddCalendarEntry( {
    calendarName =>  $some_value, # string
    createData =>  { # MyTypes::CalendarCreateData
    },
    modifyData =>  { # MyTypes::CalendarModifyData
      Description =>  $some_value, # string
      EventDate =>  $some_value, # dateTime
      EndDate =>  $some_value, # dateTime
      ReminderDate =>  $some_value, # dateTime
      ReminderTemplate =>  $some_value, # string
      FAllDayEvent =>  $some_value, # boolean
    },
  },,
 );

=head3 ModifyCalendarEntry

Modifies a calendar entry.

Returns a L<MyElements::ModifyCalendarEntryResponse|MyElements::ModifyCalendarEntryResponse> object.

 $response = $interface->ModifyCalendarEntry( {
    calendarName =>  $some_value, # string
    id =>  $some_value, # int
    User =>  { value => $some_value },
    modifyData =>  { # MyTypes::CalendarModifyData
      Description =>  $some_value, # string
      EventDate =>  $some_value, # dateTime
      EndDate =>  $some_value, # dateTime
      ReminderDate =>  $some_value, # dateTime
      ReminderTemplate =>  $some_value, # string
      FAllDayEvent =>  $some_value, # boolean
    },
  },,
 );

=head3 AddAttachment

Adds an attachment to an item.

Returns a L<MyElements::AddAttachmentResponse|MyElements::AddAttachmentResponse> object.

 $response = $interface->AddAttachment( {
    listName =>  $some_value, # string
    ID =>  $some_value, # int
    data =>  $some_value, # base64Binary
    leafName =>  $some_value, # string
  },,
 );

=head3 GetAttachment

Gets an attachment of an item by its name.

Returns a L<MyElements::GetAttachmentResponse|MyElements::GetAttachmentResponse> object.

 $response = $interface->GetAttachment( {
    listName =>  $some_value, # string
    ID =>  $some_value, # int
    leafName =>  $some_value, # string
  },,
 );

=head3 GetItems

This method is used for getting specific items from a list.

Returns a L<MyElements::GetItemsResponse|MyElements::GetItemsResponse> object.

 $response = $interface->GetItems( {
    listName =>  $some_value, # string
    User =>  { value => $some_value },
    query =>  $some_value, # string
    fields =>  { # MyTypes::ArrayOfString2
      string =>  $some_value, # string
    },
    startID =>  $some_value, # unsignedInt
    maxItems =>  $some_value, # unsignedInt
    Folder =>  { # MyTypes::Folders
      SubFolder =>  $some_value, # string
    },
    viewRecursive =>  $some_value, # boolean
  },,
 );

=head3 GetItemVersions

Gets all versions of an item.

Returns a L<MyElements::GetItemVersionsResponse|MyElements::GetItemVersionsResponse> object.

 $response = $interface->GetItemVersions( {
    listName =>  $some_value, # string
    ID =>  $some_value, # int
  },,
 );

=head3 CountItems

Counts all Items that is returned by the query.

Returns a L<MyElements::CountItemsResponse|MyElements::CountItemsResponse> object.

 $response = $interface->CountItems( {
    listName =>  $some_value, # string
    User =>  { value => $some_value },
    query =>  $some_value, # string
    Folder =>  { # MyTypes::Folders
      SubFolder =>  $some_value, # string
    },
    viewRecursive =>  $some_value, # boolean
  },,
 );

=head3 DeleteItem

Deletes an item from a list.

Returns a L<MyElements::DeleteItemResponse|MyElements::DeleteItemResponse> object.

 $response = $interface->DeleteItem( {
    listName =>  $some_value, # string
    ID =>  $some_value, # int
  },,
 );



=head1 AUTHOR

Generated by SOAP::WSDL on Tue Nov  4 17:30:58 2008

=cut
