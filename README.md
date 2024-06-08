# Nec License Preperation

## Mainsection 
 
 <div class='alert alert-block alert-info'>
 <b>Branch 09 - 01 </b></div>

 
 In this section we write abou


 #   static route() => MaterialPageRoute(builder: (context) => const AddNewQuestion());
         yo lekhne AddNewQuestion ko page ko mathi ho just func defined vako tala

 ###     Navigator.push(context, AddNewQuestion.route()); 
        yo lekhne Tyo  page ma ho jaha bata addnewquesion ko lagi call garenxa


## Change Application Icons

1. Add flutter_launcher_icons Plugin to pubspec.yaml

        e.g.

        dev_dependencies: 
        flutter_test:
            sdk: flutter

        flutter_launcher_icons: "^0.9.0"

        flutter_icons:
        image_path: "icon/icon.png" 
        android: true
        ios: true
  
2. Prepare an app icon for the specified path. e.g. icon/icon.png

3. Execute command on the terminal to Create app icons:

        $ flutter pub get

        $ flutter pub run flutter_launcher_icons:main


Use single Child scrool view to put all list in row in scrollable form and then we put all the data into array

          children: [
                  "Technology",
                  "Technology",
                  "Technology",
                  "Technology",
                  "Technology",
                ].map(
                      (e) => Chip(
                        label: Text(e),
                      ),
                    )
                    .toList(),


Yespaxi maile theme.dart ma gayerw Chip ko default property lai overwrite gare 


aba top ma list banauna parxa so that i can put all the emement inside list which i can access leter to put inside the chip



domain layer ma question vanne # entity  banaiyo ani teslai pheri data layer ma model banayerw extend gariyo


5.24
        Form Validation logic in add_new_question.dart
        