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
PlanFeature.create(plan_id: 1, feature_id: 6, value: '3')
PlanFeature.create(plan_id: 2, feature_id: 6, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 6, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 6, value: 'unlimited')

# Faq static values
Faq.create(
    question: 'Que nos trae WatchIoT',
    answer: '<mark>WatchIot</mark> es un servicio de monitoreo, que nos permite tener conocimiento en tiempo real si nuestros servicios presentan alg&uacute;n  comportamiento an&oacute;malo  o no deseado.',
    lang: 'es')

Faq.create(
    question: 'What services provided WatchIoT?',
    answer: '<mark>WatchIot</mark> is a monitoring service that allows us to know in real time and throw alert to us if our services, resources or devices (IoT) have some behavior that we want to pay attention.',
    lang: 'en')

Faq.create(
    question: 'Es WatchIoT gratis?',
    answer: '<mark>WatchIot</mark> es absolutamente gratis.',
    lang: 'es')

Faq.create(
    question: 'How much costs the service of WatchIoT?',
    answer: '<mark>WatchIot</mark> costs nothing, it is absolutely free.',
    lang: 'en')

Faq.create(
    question: 'Que es un espacio?',
    answer: 'Un espacio es una forma de organizar los servicios que usted est&aacute; monitoreando. Por ejemplo, usted puede estar monitoreando los servicios de varias empresas y puede separar cada empresa como un espacio.',
    lang: 'es')

Faq.create(
    question: 'I have to create spaces. What is a space?',
    answer: 'Space is a way of organizing the services, resources and devices (IoT) that you are monitoring. For example, maybe you are monitoring services of several companies. Then you can separate each company as a space.',
    lang: 'en')

Faq.create(
    question: 'Que es un proyecto?',
    answer: 'Cada servicio que usted monitorea se configura como un proyecto. Por ejemplo, tipo de notificaciones, que servicio voy a monitorear, cada que tiempo voy a enviar una petici&oacute;n HTTP o recibirla, a quien voy a notificar, etc.',
    lang: 'es')

Faq.create(
    question: 'I can create several projects into a space. What is a project?',
    answer: 'Each service, resource or device (IoT) that you are monitoring can be seen as a project. You can configure whole respect your service. Example: url to send a request, ip for wait the request, when throw the alert (notification), email that must receive the notification, etc.',
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
    answer: 'You have the ability to invite friends to help you manage spaces and projects, and receive alerts. In <mark>WatchIoT</mark> it is very easy',
    lang: 'en')

Faq.create(
    question: 'Que tipo de notificaciones recibo?',
    answer: 'Usted recibir&aacute; notificaciones en tiempo real v&iacute;a email, adem&aacute;s de poder configurar <mark>WebHooks</mark> como forma de notificaci&oacute;n.',
    lang: 'es')

Faq.create(
    question: 'What type of reports i can receive?',
    answer: 'You will receive notifications in real time via email, plus you can set <mark>WebHooks</mark> as a form of notification. In the future you will can receive sms too.',
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
    description: 'You can monitor several platforms, like <mark>IOS, Windows, Linux, Android, etc</mark> and can even monitor your cloud services or web applications, in addition to devices (Internet of Things) too.',
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
    description: 'The power of <mark>WatchIoT</mark> is that everything is configurable and incredibly simple. You can configure all about how you want to handle your services, resources and devices (IoT) and send alert for many way.',
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
    description: 'Notifications are in real time via email and <mark>WebHooks</mark> for now. Feel safe, you have everything under control and can sleep relaxed we will be alert for you.',
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
    description: '<mark>WatchIoT</mark> can make <mark>HTTPS</mark> requests their services or their services may send <mark>HTTPS</mark> requests to us, depending on your needs.',
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
    description: 'You have two ways of processing the data collected by your services and decide whether or not to notify. Using <mark>WebForm</mark> or more powerful configuration language.',
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
    description: 'Every time we recover data from your services, keep in shape history and offer the possibility of graphically the behavior in time of your monitored services, resurces or devices (IoF).',
    icon: 'area-chart',
    lang: 'en'
)
