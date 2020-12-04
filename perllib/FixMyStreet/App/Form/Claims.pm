package FixMyStreet::App::Form::Claims;

use HTML::FormHandler::Moose;
extends 'FixMyStreet::App::Form::Wizard';

has c => ( is => 'ro' );

has default_page_type => ( is => 'ro', isa => 'Str', default => 'Claims' );

has finished_action => ( is => 'ro' );

before _process_page_array => sub {
    my ($self, $pages) = @_;
    foreach my $page (@$pages) {
        $page->{type} = $self->default_page_type
            unless $page->{type};
    }
};

# Add some functions to the form to pass through to the current page
has '+current_page' => (
    handles => {
        intro_template => 'intro',
        title => 'title',
        template => 'template',
    }
);

has_page intro => (
    fields => ['start'],
    title => 'Claim for Damages',
    intro => 'start.html',
    next => 'what',
);

has_page what => (
    fields => ['what', 'continue'],
    title => 'What are you claiming for',
    next => 'about_you',
);

has_field what => (
    required => 1,
    type => 'Select',
    widget => 'RadioGroup',
    label => 'What are you claiming for?',
    options => [
        { value => '0', label => 'Vehicle damage' },
        { value => '1', label => 'Personal injury' },
        { value => '2', label => 'Property' },
    ]
);


has_page about_you => (
    fields => ['name', 'phone', 'email', 'address', 'continue'],
    title => 'About you',
    next => 'about_fault',
);

with 'FixMyStreet::App::Form::Claims::AboutYou';

has_field address => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Address',
);


has_page about_fault => (
    fields => ['report_id', 'continue'],
    title => 'About the fault',
    next => 'where',
);

has_field report_id => (
    required => 1,
    type => 'Text',
    label => 'Fault ID',
);

has_page where => (
    fields => ['location', 'continue'],
    title => 'Where did the incident happen',
    next => 'when',
);

has_field location => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Location',
);

has_page when => (
    fields => ['date', 'time', 'continue'],
    title => 'When did the incident happen',
    next => 'details',
);

has_field date => (
    required => 1,
    type => 'Text',
    label => 'Date',
);

has_field time => (
    required => 1,
    type => 'Text',
    label => 'Time',
);

has_page details => (
    fields => ['weather', 'direction', 'details', 'in_vehicle', 'speed', 'actions', 'continue'],
    title => 'What are the details of the incident',
    next => 'witnesses',
);

has_field weather => (
    required => 1,
    type => 'Text',
    label => 'Describe the weather conditions at the time',
);

has_field direction => (
    required => 1,
    type => 'Text',
    label => 'What direction were you travelling in at the time',
);

has_field details => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Describe the details of the incident',
);

has_field in_vehicle => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Where you in a vehicle when the incident happened?',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field speed => (
    required => 1,
    type => 'Text',
    label => 'What speed was the vehicle travelling?',
);

has_field actions => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'If you were not driving, what were you doing when the incident happened?',
);

has_page witnesses => (
    fields => ['witnesses', 'witness_details', 'report_police', 'incident_number', 'continue'],
    title => 'Witnesses and police',
    next => 'cause',
);

has_field witnesses => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Were there any witnesses?',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field witness_details => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Please give the witness\' details',
);

has_field report_police => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Did you report the incident to the police',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field incident_number => (
    required => 1,
    type => 'Text',
    label => 'What was the incident reference number?',
);


has_page cause => (
    fields => ['what_cause', 'aware', 'where_cause', 'describe_cause', 'photos', 'continue'],
    title => 'What caused the incident?',
    next => $_[0]->{what} == 0 ? 'about_vehicle' :
            $_[0]->{what} == 1 ? 'about_property' :
            'about_you_personal',
);

has_field what_cause => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'What was the cause of the incident',
    options => [
        { label => 'Bollard', value => 'bollard' },
        { label => 'Cats Eyes', value => 'catseyes' },
        { label => 'Debris', value => 'debris' },
    ],
);

has_field aware => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Were you aware of it before?',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field where_cause => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Where was the cause of the incident',
    options => [
        { label => 'Bridge', value => 'bridge' },
        { label => 'Carriageway', value => 'carriageway' },
    ],
);

has_field describe_cause => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Describe the incident cause',
);

has_field photos => (
    type => 'Text',
    label => 'Please provide two dated photos of the incident',
);

has_page about_vehicle => (
    fields => ['make', 'registration', 'mileage', 'v5', 'v5_in_name', 'insurer_address', 'damage_claim', 'vat_reg', 'continue'],
    title => 'About the vehicle',
    next => 'damage_vehicle',
);

has_field make => (
    required => 1,
    type => 'Text',
    label => 'Make and model',
);

has_field registration => (
    required => 1,
    type => 'Text',
    label => 'Registration number',
);

has_field mileage => (
    required => 1,
    type => 'Text',
    label => 'Vehicle mileage',
);

has_field v5 => (
    required => 1,
    type => 'Text',
    label => 'V5',
);

has_field v5_in_name => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Is the V5 in your name',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field insurer_address => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Insurer address',
);

has_field damage_claim => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Are you making a claim via insurers',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field vat_reg => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Are you registered for VAT?',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_page damage_vehicle => (
    fields => ['vehicle_damage', 'vehicle_photos', 'vehicle_receipts', 'tyre_damage', 'tyre_mileage', 'tyre_receipts', 'continue'],
    title => 'What was the damage to the vehicle',
    next => 'summary',
);

has_field vehicle_damage => (
    required => 1,
    type => 'Text',
    widget => 'Textarea',
    label => 'Describe the damage to the vehicle',
);

has_field vehicle_photos => (
    required => 1,
    type => 'Text',
    label => 'Please provide two photos of the damage to the vehicle',
);

has_field vehicle_receipts=> (
    required => 1,
    type => 'Text',
    label => 'Please provide receipted invoiced for repairs',
);

has_field tyre_mileage => (
    required => 1,
    type => 'Text',
    label => 'Tyre Mileage',
);

has_field tyre_damage => (
    type => 'Select',
    widget => 'RadioGroup',
    required => 1,
    label => 'Are you claiming for tyre damage?',
    options => [
        { label => 'Yes', value => '1' },
        { label => 'No', value => '0' },
    ],
);

has_field tyre_receipts => (
    required => 1,
    type => 'Text',
    label => 'Please provide copy of tyre purchase receipts',
);

has_page about_property => (
    fields => ['continue'],
    title => 'About the property',
    next => 'damage_property',
);

has_page damage_property => (
    fields => ['continue'],
    title => 'What was the damage to the property',
    next => 'summary',
);

has_page about_you_personal => (
    fields => ['continue'],
    title => 'About you',
    next => 'injuries',
);

has_page injuries => (
    fields => ['continue'],
    title => 'About your injuries',
    next => 'summary',
);


has_page summary => (
    fields => ['submit'],
    title => 'Review',
    template => 'claims/summary.html',
    finished => sub {
        my $form = shift;
        my $c = $form->c;
        my $success = $c->forward('process_claim', [ $form ]);
        if (!$success) {
            $form->add_form_error('Something went wrong, please try again');
            foreach (keys %{$c->stash->{field_errors}}) {
                $form->add_form_error("$_: " . $c->stash->{field_errors}{$_});
            }
        }
        return $success;
    },
    next => 'done',
);

has_page done => (
    title => 'Submit',
    template => 'claims/confirmation.html',
);

has_field start => ( type => 'Submit', value => 'Start', element_attr => { class => 'govuk-button' } );
has_field continue => ( type => 'Submit', value => 'Continue', element_attr => { class => 'govuk-button' } );
has_field submit => ( type => 'Submit', value => 'Submit', element_attr => { class => 'govuk-button' } );

1;
