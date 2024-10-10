namespace :db do
  desc "Check if specified emails exist in the database and output missing ones"
  task check_emails_exist: :environment do
    emails_to_check = %w[
maud.miribel@edubga.com
gabrielle.oliveira@edubga.com
samantha.pires@edubga.com
belen.garcia@edubga.com
lucciana.fonseca@edubga.com
aldiyar.issin@edubga.com
alina.issina@edubga.com
cedric.velde@edubga.com
daphne.deglon@edubga.com
nassim.jebari@edubga.com

luca.dinis@edubga.com
sol.dikkenberg@edubga.com
alara.simsek@edubga.com
arran.guthrie-strachan@edubga.com
caleb.uitenbroek@edubga.com
cristian.velde@edubga.com
choying.pelmo@edubga.com
sonoma.rushing@edubga.com
lachlan.gibson@edubga.com
noah.sweeney@edubga.com
catharina.boer@edubga.com
georgia.macdonald@edubga.com
robert.macdonald@edubga.com
rebecca.hewitt@edubga.com
senne.decock@edubga.com
kiano.silva@edubga.com
sarah.abuabara@edubga.com
david.prior@edubga.com
fernando.wilson@edubga.com
jade.steyn@edubga.com
joao.campos@edubga.com
keanu.schwedt@edubga.com
manuel.jordao@edubga.com
mekhai.maharaj@gmail.com
tiago.nogueira@edubga.com
sofia.hernandez@edubga.com
akari.roggio@edubga.com
mees.rodenburg@edubga.com
david.sicko@edubga.com
nayana.avellar@edubga.com
finlay.low@edubga.com
matthew.roux@edubga.com

ashtonhowie10@gmail.com
elijah.buffington@edubga.com
isabella.boer@edubga.com
jake.lloyd@edubga.com
reef.sweeney@edubga.com
julian.klatt@edubga.com
peter.schmidt@edubga.com
damien.dos.santos@edubga.com
mvgent@me.com
francisco.castro@edubga.com
adam.halsband@edubga.com
aiden.ward@edubga.com
jessica.griffith@edubga.com
svea.gottstein@edubga.com
asger.skov@edubga.com
keggiemischa@gmail.com
anabella.acevedo@edubga.com
elwyn.harborne@edubga.com
mateus.guimaraes@edubga.com
michael.aviv@edubga.com
laiba.faridi@edubga.com
tania.venter@edubga.com
naomi.zonenberga@edubga.com
odrija.zonenberga@edubga.com
maitailisbon@gmail.com
ilay.ziv@edubga.com
samuel.fradin@edubga.com
indiana.sweeney@edubga.com
jora.wees@edubga.com
stefan.igorovitch@edubga.com

natan.sicko@edubga.com
hannah.schmidt@edubga.com

annya.artemenko@gmail.com
ellagracelev@gmail.com
bianca.berevoescu.miranda@gmail.com
sumababy@gmail.com
talaibek60@msn.com
seph.amzic@gmail.com
ashianagupta8@gmail.com
rosenkilde76@gmail.com
sandra@cleantechchem.co.za

wszonja2008@gmail.com
domewiedermann@gmail.com
lilyobrien0333@gmail.com
info@eliserijnberg.com
noctorsophie07@gmail.com
oliverburkinshaw99@gmail.com
    ]

    # Find missing emails
    missing_emails = emails_to_check.reject do |email|
      User.exists?(email: email)
    end

    # Output the result
    if missing_emails.any?
      puts "The following emails were not found in the database:"
      puts missing_emails
    else
      puts "All emails are present in the database."
    end
  end
end
