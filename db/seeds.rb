# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create plans static values
Plan.create(name: 'Free', amount_per_month: 0)
Plan.create(name: 'Small', amount_per_month: 9)
Plan.create(name: 'Medium', amount_per_month: 19)
Plan.create(name: 'Large', amount_per_month: 29)

Feature.create(name: 'Number of spaces')
Feature.create(name: 'Number of projects by space')
Feature.create(name: 'Request per minutes')
Feature.create(name: 'Notification by email')
Feature.create(name: 'Webhook support')
Feature.create(name: 'Team members')

# Number of spaces
PlanFeature.create(plan_id: 1, feature_id: 1, value: '3')
PlanFeature.create(plan_id: 2, feature_id: 1, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 1, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 1, value: '30')

# Number of projects by space
PlanFeature.create(plan_id: 1, feature_id: 2, value: '5')
PlanFeature.create(plan_id: 2, feature_id: 2, value: '10')
PlanFeature.create(plan_id: 3, feature_id: 2, value: '15')
PlanFeature.create(plan_id: 4, feature_id: 2, value: '30')

# Request per minutes
PlanFeature.create(plan_id: 1, feature_id: 3, value: '1')
PlanFeature.create(plan_id: 2, feature_id: 3, value: '15')
PlanFeature.create(plan_id: 3, feature_id: 3, value: '30')
PlanFeature.create(plan_id: 4, feature_id: 3, value: '60')

# Notification by email
PlanFeature.create(plan_id: 1, feature_id: 4, value: 'true')
PlanFeature.create(plan_id: 2, feature_id: 4, value: 'true')
PlanFeature.create(plan_id: 3, feature_id: 4, value: 'true')
PlanFeature.create(plan_id: 4, feature_id: 4, value: 'true')

# Webhook support'
PlanFeature.create(plan_id: 1, feature_id: 5, value: 'false')
PlanFeature.create(plan_id: 2, feature_id: 5, value: 'true')
PlanFeature.create(plan_id: 3, feature_id: 5, value: 'true')
PlanFeature.create(plan_id: 4, feature_id: 5, value: 'true')

# Team members
PlanFeature.create(plan_id: 1, feature_id: 6, value: '1')
PlanFeature.create(plan_id: 2, feature_id: 6, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 6, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 6, value: 'unlimited')

# Faq static values
Faq.create(
    question: 'Que nos trae WatchIoT',
    answer: '<mark>WatchIot</mark> es un servicio de monitoreo, que nos permite tener conocimiento en tiempo real si nuestros servicios presentan alg&uacute;n  comportamiento an&oacute;malo  o no deseado.',
    lang: 'es')

Faq.create(
    question: 'Which brings us WatchIoT?',
    answer: '<mark>WatchIot</mark> is a monitoring service that allows us to know in real time if our services they have some anomalous behavior or unwanted.',
    lang: 'en')

Faq.create(
    question: 'Es WatchIoT gratis?',
    answer: '<mark>WatchIot</mark> es absolutamente gratis.',
    lang: 'es')

Faq.create(
    question: 'Is WatchIoT free',
    answer: '<mark>WatchIot</mark> is absolutely free.',
    lang: 'en')

Faq.create(
    question: 'Que es un espacio?',
    answer: 'Un espacio es una forma de organizar los servicios que usted est&aacute; monitoreando. Por ejemplo, usted puede estar monitoreando los servicios de varias empresas y puede separar cada empresa como un espacio.',
    lang: 'es')

Faq.create(
    question: 'What is a space?',
    answer: 'A space is a way of organizing the services you are monitoring. For example, you may be monitoring services of several companies can separate each company as a space.',
    lang: 'en')

Faq.create(
    question: 'Que es un proyecto?',
    answer: 'Cada servicio que usted monitorea se configura como un proyecto. Por ejemplo, tipo de notificaciones, que servicio voy a monitorear, cada que tiempo voy a enviar una petici&oacute;n HTTP o recibirla, a quien voy a notificar, etc.',
    lang: 'es')

Faq.create(
    question: 'What is a project?',
    answer: 'Each service that you monitor is configured as a project. For example such notifications, which will monitor service. Every time that I will send a HTTP request or receive, has who will notify, etc.',
    lang: 'en')

Faq.create(
    question: 'Cuantos espacios puedo tener realcionado a mi cuenta?',
    answer: 'Usted puede crear un m&aacute;ximo de 3 espacios. Si usted requiere m&aacute;s espacios por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es')

Faq.create(
    question: 'How many spaces can be related to my account?',
    answer: 'You can create a maximum of 3 spaces. If you require more space please contact us.',
    lang: 'en')

Faq.create(
    question: 'Cuantos proyectos puedo tener por espacio?',
    answer: 'Usted puede tener un m&aacute;ximo de 5 proyectos por espacio. Si usted requiere m&aacute;s proyectos por espacio por favor p&oacute;ngase en contacto con nosotros.',
    lang: 'es')

Faq.create(
    question: 'How many projects for space?',
    answer: 'You can have a maximum of 5 projects for space. If you require more space projects please contact us.',
    lang: 'en')

Faq.create(
    question: 'Puedo agregar amigos para que administren mis espacios y proyectos',
    answer: 'Usted tiene la posibilidad de invitar amigos a que le ayuden a administrar los espacios y proyectos, adem&aacute;s de recibir alertas.',
    lang: 'es')

Faq.create(
    question: 'Can i add friends to manage the spaces and projects?',
    answer: 'You have the ability to invite friends to help you manage spaces and projects, and receive alerts.',
    lang: 'en')

Faq.create(
    question: 'Que tipo de notificaciones recibo?',
    answer: 'Usted recibir&aacute; notificaciones en tiempo real v&iacute;a email, adem&aacute;s de poder configurar <mark>WebHooks</mark> como forma de notificaci&oacute;n.',
    lang: 'es')

Faq.create(
    question: 'What kind of reports I get?',
    answer: 'You will receive notifications in real time via email, plus you can set <mark>WebHooks</mark> as a form of notification.',
    lang: 'en')

# Project descriptions static values
Descrip.create(
    title: 'Multiplataforma',
    description: 'Usted puede monitorear diferentes plataformas, como <mark>Linux, Mac o Windows</mark> e incluso puede monitorear sus servicios en la nube, adem&aacute;s de dispositivos IoT (Internet de las cosas).',
    icon: 'cubes',
    lang: 'es'
)

Descrip.create(
    title: 'Multiplatform',
    description: 'You can monitor various platforms, including <mark>Linux, Mac or Windows</mark> and can even monitor your cloud services, in addition to IoT devices (Internet of Things).',
    icon: 'cubes',
    lang: 'en'
)

Descrip.create(
    title: 'Configurable',
    description: 'El poder de <mark>WatchIoT</mark> radica en que todo es configurable e incre&iacute;blemente simple. Usted configura que servidor, terminal, recurso o servicio desea monitorear.',
    icon: 'cog',
    lang: 'es'
)

Descrip.create(
    title: 'Configurable',
    description: 'The power of <mark>WatchIoT</mark> is that everything is configurable and incredibly simple. You configure that server, terminal, resource or service you want to monitor.',
    icon: 'cog',
    lang: 'en'
)

Descrip.create(
    title: 'Notificacion',
    description: 'Las notificaciones son v&iacute;a email y <mark>WebHooks</mark> en tiempo real. Quedese tranquilo, usted tiene todo bajo control ya puede dormir relajado, nosotros vamos a estar alerta por usted.',
    icon: 'envelope',
    lang: 'es'
)

Descrip.create(
    title: 'Notification',
    description: 'Notifications are <mark>WebHooks</mark> via email and in real time. Feel safe, you have everything under control and can sleep relaxed we will be alert for you.',
    icon: 'envelope',
    lang: 'en'
)

Descrip.create(
    title: 'Bidireccional',
    description: '<mark>WatchIoT</mark> puede realizar las peticiones <mark>HTTP</mark> a sus servicios o sus servicios pueden enviarnos peticiones <mark>HTTP</mark> a nosotros, en dependencia de sus necesidades.',
    icon: 'arrows-h',
    lang: 'es'
)

Descrip.create(
    title: 'Bidirectional',
    description: '<mark>WatchIoT</mark> can make <mark>HTTP</mark> requests their services or their services may send <mark>HTTP</mark> requests to us, depending on your needs.',
    icon: 'arrows-h',
    lang: 'en'
)

Descrip.create(
    title: 'Scripting',
    description: 'Usted tiene dos formas de procesar los datos recopilados de sus servicios y tomar decisiones de notificar o no. Configur&aacute;ndolo por formulario o utilizando un lenguaje de scripting.',
    icon: 'code',
    lang: 'es'
)

Descrip.create(
    title: 'Scripting',
    description: 'You have two ways of processing the data collected by its services and decide whether or not to notify. Form or setting it by using a scripting language.',
    icon: 'code',
    lang: 'en'
)

Descrip.create(
    title: 'Charting',
    description: 'Cada vez que nosotros recopilamos los datos de sus servicios, los guardamos en forma de historial y brindamos la posibilidad de mostrarlo de forma gr&aacute;fica el comportamiento en el tiempo de sus servicios monitoreados.',
    icon: 'area-chart',
    lang: 'es'
)

Descrip.create(
    title: 'Charting',
    description: 'Every time we recover data from their services, keep in shape history and offer the possibility of graphically the behavior in time of their monitored services.',
    icon: 'area-chart',
    lang: 'en'
)

# Permission static values (TODO: review this feature)
# Permission.create(category: 'global', permission: 'create_space') # Can create spaces
# Permission.create(category: 'global', permission: 'edit_space') # Can edit any space
# Permission.create(category: 'global', permission: 'delete_space') # Can delete any space
# Permission.create(category: 'global', permission: 'setting_space') # Can setting any space

# Permission.create(category: 'space', permission: 'edit_space') # Can edit a space
# Permission.create(category: 'space', permission: 'delete_space') # Can delete a space
# Permission.create(category: 'space', permission: 'setting_space') # Can setting a space
