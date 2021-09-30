import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:addictx/pages/specificDiet.dart';
import 'package:addictx/widgets/customExpansionTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DietList extends StatelessWidget {
  List<String> addictionName=[
    'SOCIAL MEDIA','FAST FOOD','OVEREATING',
    'GAMING','PROCRASTINATION','GAMBLING',
    'SMOKING','ALCOHOL','DRUGS',
    'WEED','WATCHING TV','LYING',
    'COFFEE','QUARREL','NOT SLEEPING'
  ];
  Map<String, List> addictionDescription={
    'English':['Eat before you miss the latest update.',"In the long run fast food will ruin your body's future.",'I saw extra carbs poisoning your meals.', 'Chicken dinner is best when saved on the table.','If you delay eating food, it will delay your happiness','Gamble your deserted plate with decorated food.', 'Fill your tummy with food and not lungs with smoke.','Food before drink to differ between better and best food.','Try good food, it is better than drugs.', 'Focus on feed to forget weed.','Turn your back on a tv show and relish your food.','You can survive without falsehoods but not food.', 'Coffee is better but tastes best with food on a plate.','Never show food your anger, as food helps you feel good.','Sleep betrayal is allowed but food betrayal is prohibited.'],
    'Hindi':['नवीनतम अपडेट याद करने से पहले खाएं।','लंबे समय में फास्ट फूड आपके शरीर के भविष्य को बर्बाद कर देगा।','मैंने देखा कि अतिरिक्त कार्ब्स आपके भोजन में जहर घोल रहे हैं।', 'मेज पर सहेजे जाने पर चिकन डिनर सबसे अच्छा होता है।','यदि आप खाने में देरी करते हैं, तो यह आपकी खुशी में देरी करेगा।','अपनी सुनसान थाली को सजाए हुए भोजन से सजाएं।', 'अपने पेट को भोजन से भरें न कि फेफड़ों को धुएं से।','पीने से पहले भोजन बेहतर और सर्वोत्तम भोजन के बीच अंतर करना।','अच्छा खाना खाने की कोशिश करो, यह दवाओं से बेहतर है।', 'खरपतवार को भूलने के लिए फ़ीड पर ध्यान दें।','एक टीवी शो से अपनी पीठ फेरें और अपने भोजन का आनंद लें।','आप असत्य के बिना जीवित रह सकते हैं लेकिन भोजन नहीं।', 'कॉफी बेहतर है लेकिन प्लेट में खाने के साथ सबसे अच्छी लगती है।','भोजन को कभी भी अपना क्रोध न दिखाएं, क्योंकि भोजन आपको अच्छा महसूस कराने में मदद करता है।','नींद में विश्वासघात की अनुमति है लेकिन खाद्य विश्वासघात निषिद्ध है।'],
    'Spanish':['Come antes de perderte la última actualización.','A la larga, la comida rápida arruinará el futuro de su cuerpo.','Vi carbohidratos adicionales envenenando sus comidas.',"La cena de pollo es mejor cuando se guarda en la mesa.",'Si demoras en comer, retrasará tu felicidad.','Juegue su plato vacío con comida decorada.', 'Llena tu barriga de comida y no los pulmones de humo.','Comida antes de beber para diferenciar entre mejor y mejor comida.','Prueba la buena comida, es mejor que las drogas.', 'Concéntrese en la alimentación para olvidar la marihuana.','Dale la espalda a un programa de televisión y disfruta de tu comida.','Puedes sobrevivir sin falsedades pero sin comida.', 'El café es mejor pero sabe mejor con comida en un plato.','Nunca muestres tu enojo a la comida, ya que la comida te ayuda a sentirte bien.','Se permite la traición del sueño, pero la traición a la comida está prohibida.'],
    'German':['Essen Sie, bevor Sie das neueste Update verpassen.','Auf lange Sicht ruiniert Fast Food die Zukunft Ihres Körpers.','Ich habe gesehen, wie zusätzliche Kohlenhydrate Ihre Mahlzeiten vergiftet haben.', 'Hühnchenessen ist am besten, wenn es auf dem Tisch aufbewahrt wird.','Wenn Sie das Essen hinauszögern, wird es Ihr Glück verzögern','Spielen Sie Ihren verlassenen Teller mit dekoriertem Essen.', 'Füllen Sie Ihren Bauch mit Nahrung und nicht Ihre Lungen mit Rauch.','Essen vor dem Trinken, um zwischen besserem und bestem Essen zu unterscheiden.','Probieren Sie gutes Essen, es ist besser als Drogen.', 'Konzentrieren Sie sich auf das Futter, um Unkraut zu vergessen.','Drehen Sie einer Fernsehsendung den Rücken zu und genießen Sie Ihr Essen.','Sie können ohne Lügen überleben, aber ohne Nahrung.', 'Kaffee ist besser, schmeckt aber am besten mit Essen auf einem Teller.','Zeigen Sie Ihrem Essen niemals Ihre Wut, denn Essen hilft Ihnen, sich gut zu fühlen.','Schlafverrat ist erlaubt, aber Lebensmittelverrat ist verboten.'],
    'French':['Mangez avant de manquer la dernière mise à jour.',"À long terme, la restauration rapide ruinera l'avenir de votre corps.","J'ai vu des glucides supplémentaires empoisonner vos repas.", "Le dîner de poulet est meilleur lorsqu'il est conservé sur la table.",'Si vous tardez à manger, cela retardera votre bonheur',"Jouez votre assiette déserte avec de la nourriture décorée.", 'Remplissez votre ventre de nourriture et non vos poumons de fumée.',"Nourriture avant boisson pour faire la différence entre la meilleure et la meilleure nourriture.","Essayez la bonne nourriture, c'est mieux que la drogue.", "Concentrez-vous sur l'alimentation pour oublier les mauvaises herbes.",'Tournez le dos à une émission de télévision et savourez votre nourriture.','Vous pouvez survivre sans mensonges mais sans nourriture.', 'Le café est meilleur mais a meilleur goût avec de la nourriture dans une assiette.','Ne montrez jamais votre colère à la nourriture, car la nourriture vous aide à vous sentir bien.','La trahison du sommeil est autorisée mais la trahison alimentaire est interdite.'],
    'Japanese':['最新のアップデートを見逃す前に食べてください。','長期的には、ファーストフードはあなたの体の未来を台無しにします。','私はあなたの食事を中毒する余分な炭水化物を見ました。', 'チキンディナーはテーブルに保存しておくと最高です。','あなたが食べ物を食べるのを遅らせると、それはあなたの幸せを遅らせるでしょう','飾られた食べ物であなたの捨てられた皿を賭けてください。', '肺ではなく、おなかを食べ物で満たしてください。','飲む前の食べ物は、より良い食べ物と最高の食べ物で異なります。','良い食べ物を試してみてください、それは薬よりも優れています。', '雑草を忘れるために飼料に焦点を合わせます。','テレビ番組に背を向けて、食べ物を楽しんでください。','あなたは虚偽なしで生き残ることができますが、食べ物はありません。', 'コーヒーの方が良いですが、皿に盛り付けた料理が一番おいしいです。','食べ物は気分を良くするのに役立つので、食べ物に怒りを見せないでください。','睡眠の裏切りは許可されていますが、食品の裏切りは禁止されています。'],
    'Russian':['Ешьте, прежде чем пропустите последнее обновление.','В конечном итоге фастфуд разрушит будущее вашего тела.','Я видел, как лишние углеводы отравляют вашу еду.', 'Куриный ужин лучше всего сохранить на столе.','Если вы откладываете прием пищи, это замедлит ваше счастье', 'Сделайте ставку на свою заброшенную тарелку с украшенной едой.','Наполняйте животик едой, а не дымом легкие.','Essen vor dem Trinken, um zwischen besserem und bestem Essen zu unterscheiden.', 'Попробуйте хорошую еду, это лучше, чем лекарства.','Сосредоточьтесь на корме, чтобы забыть о травке.','Отвернитесь от телешоу и наслаждайтесь едой.','Вы можете выжить без лжи, но без еды.', 'Кофе лучше, но вкуснее всего с едой на тарелке.','Никогда не показывайте еде свой гнев, так как еда помогает вам чувствовать себя хорошо.','Предательство сна разрешено, но предательство еды запрещено.'],
    'Chinese':['在您错过最新更新之前先吃饱。','从长远来看，快餐会毁了你身体的未来。','我看到额外的碳水化合物使你的饭菜中毒。','鸡肉晚餐最好放在桌子上。','如果你延迟吃食物，它就会延迟你的幸福。','用装饰过的食物来赌博你的废弃盘子。','用食物填满你的肚子，而不是用烟雾填满你的肺。','喝酒前的食物以区分更好和最好的食物。','尝尝美食，胜过药物。','专注于饲料以忘记杂草。','拒绝电视节目，享受美食。','你可以在没有谎言的情况下生存，但没有食物。','咖啡更好，但与盘子上的食物搭配时味道最好。','永远不要向食物表达你的愤怒，因为食物会让你感觉良好。','允许背叛睡眠，但禁止背叛食物。'],
    'Portuguese':['Coma antes de perder a última atualização.','A longo prazo, o fast food arruinará o futuro do seu corpo.','Eu vi carboidratos extras envenenando suas refeições.', 'O jantar de frango é melhor quando guardado na mesa.','Se você demorar a comer, isso atrasará sua felicidade','Jogue seu prato deserto com comida decorada.', 'Encha a barriga com comida e não os pulmões com fumaça.','A comida antes da bebida é diferente entre a melhor e a melhor comida.','Experimente uma boa comida, é melhor do que drogas.', 'Concentre-se na alimentação para esquecer a erva daninha.','Vire as costas para um programa de TV e saboreie sua comida.','Você pode sobreviver sem falsidades, mas não pode comer.', 'O café é melhor, mas fica melhor com comida no prato.','Nunca mostre sua raiva pela comida, pois a comida ajuda você a se sentir bem.','A traição durante o sono é permitida, mas a traição alimentar é proibida.'],
  };
  Map<String, List> addictions={
    'English':['SOCIAL MEDIA','FAST FOOD','OVEREATING', 'GAMING','PROCRASTINATION','GAMBLING', 'SMOKING','ALCOHOL','DRUGS', 'WEED','WATCHING TV','LYING', 'COFFEE','QUARREL','NOT SLEEPING'],
    'Hindi':['सामाजिक मीडिया','फास्ट फूड','ज्यादा खाना', 'गेमिंग','टालमटोल करना','जुआ', 'धूम्रपान','शराब','ड्रग्स', 'जंगली घास','टीवी देखना','झूठ बोलना', 'कॉफ़ी','लड़ाई झगड़ा','नहीं सोना'],
    'Spanish':['MEDIOS DE COMUNICACIÓN SOCIAL','COMIDA RÁPIDA','COMER EN EXCESO','JUEGO DE AZAR','DILACIÓN','JUEGO', 'DE FUMAR','ALCOHOL','DROGAS', 'HIERBA','VIENDO LA TELEVISIÓN','MINTIENDO', 'CAFÉ','PELEA','NO DURMIENDO'],
    'German':['SOZIALEN MEDIEN','FASTFOOD','ÜBERESSEN', 'SPIELE','AUFSCHUB','SPIELEN', 'RAUCHEN','ALKOHOL','DROGEN', 'GRAS','FERNSEHEN','LÜGEN', 'KAFFEE','STREIT','NICHT SCHLAFEND'],
    'French':['DES MÉDIAS SOCIAUX','MAL BOUFFE','TROP MANGER', 'JEU','PROCRASTINATION',"JEUX D'ARGENT", 'FUMEUSE',"DE L'ALCOOL",'DROGUES', 'CANNABIS','REGARDER LA TÉLÉVISION','MENSONGE', 'CAFÉ','QUERELLE','NE PAS DORMIR'],
    'Japanese':['ソーシャルメディア','ファストフード','過食', 'ゲーム','怠慢','ギャンブル', '喫煙','アルコール','薬物', '雑草','テレビを見ている','嘘をつく', 'コーヒー','喧嘩','寝ていません'],
    'Russian':['СОЦИАЛЬНЫЕ МЕДИА','БЫСТРОЕ ПИТАНИЕ','ПЕРЕЕДАНИЕ', 'ИГРОВЫЕ','ПРОКРАСТИНАЦИЯ','ИГРАТЬ В АЗАРТНЫЕ ИГРЫ', 'КУРЕНИЕ','АЛКОГОЛЬ','НАРКОТИКИ', 'СОРНЯК','СМОТРЯ ТЕЛЕВИЗОР','ВРУЩИЙ', 'КОФЕ','ССОРИТЬСЯ','НЕ СПИТ'],
    'Chinese':['社交媒体','快餐','暴饮暴食', '赌博','拖延','赌博', '抽烟','酒精','药物', '杂草','看电视','凌', '咖啡','吵架','不睡觉'],
    'Portuguese':['MÍDIA SOCIAL','COMIDA RÁPIDA','COMER DEMAIS', 'JOGOS','PROCRASTINAÇÃO','JOGATINA', 'FUMAR','ÁLCOOL','DROGAS', 'ERVA','ASSISTINDO TV','DEITADA', 'CAFÉ','BRIGA','NÃO DORME'],
  };
  Map<String, List> dietHeading={
    'English':['Breakfast', 'Lunch', 'Snacks', 'Dinner',],
    'Hindi':['सुबह का नाश्ता', 'दोपहर का भोजन', 'शाम का नाश्ता', 'रात का खाना',],
    'Spanish':['Desayuno', 'Almuerza', 'Aperitivos', 'Cena',],
    'German':['Frühstück', 'Mittagessen', 'Snacks', 'Abendessen',],
    'French':['Petit-déjeuner', 'Déjeuner', 'Collations', 'Dîner',],
    'Japanese':['朝ごはん', 'ランチ', 'おやつ', '晩ごはん',],
    'Russian':['Завтрак', 'Обед', 'Закуски', 'Обед',],
    'Chinese':['早餐', '午餐', '零食', '晚餐',],
    'Portuguese':['Café da manhã', 'Almoço', 'Lanches', 'Jantar',],
  };
  Map<String, List> dietDescription={
    'English':['A delightful day is powered by a beautiful breakfast', 'Defying lunch will deliver you to hell.', 'Snacks are secret fuel to fabulousness.', 'Dinner will help you become a winner.',],
    'Hindi':['एक रमणीय दिन एक सुंदर नाश्ते द्वारा संचालित होता है', 'दोपहर के भोजन की अवहेलना आपको नरक में पहुंचा देगी।', 'स्नैक्स शानदारता के लिए गुप्त ईंधन हैं।', 'रात का डिनर आपको विजेता बनने में मदद करेगा।',],
    'Spanish':['Un día delicioso es impulsado por un hermoso desayuno.', 'Desafiar el almuerzo te llevará al infierno.', 'Los bocadillos son el combustible secreto de la fabulosidad.', 'La cena te ayudará a convertirte en un ganador.',],
    'German':['Ein herrlicher Tag wird von einem schönen Frühstück angetrieben', 'Sich dem Mittagessen zu widersetzen wird dich in die Hölle bringen.', 'Snacks sind der geheime Treibstoff für Fabelhaftes.', 'Das Abendessen wird Ihnen helfen, ein Gewinner zu werden.',],
    'French':['Une journée délicieuse est alimentée par un beau petit déjeuner', 'Défier le déjeuner vous conduira en enfer.', 'Les collations sont le carburant secret de la fabuleuse.', 'Le dîner vous aidera à devenir un gagnant.',],
    'Japanese':['楽しい一日は美しい朝食によって支えられています', '昼食に逆らうと地獄に落ちます。', 'スナックは素晴らしさへの秘密の燃料です。', '夕食はあなたが勝者になるのに役立ちます。',],
    'Russian':['Прекрасный день наполнен прекрасным завтраком', 'Отказ от обеда доставит вас в ад.', 'Закуски - секретное топливо сказочности.', 'Ужин поможет вам стать победителем.',],
    'Chinese':['美好的一天源于一顿美餐', '违抗午餐会让你下地狱。', '零食是美妙的秘密燃料。', '晚餐将帮助您成为赢家。',],
    'Portuguese':['Um dia delicioso é alimentado por um lindo café da manhã', 'Desafiar o almoço o levará ao inferno.', 'Os lanches são o combustível secreto para o fabuloso.', 'O jantar o ajudará a se tornar um vencedor.',],
  };
  Map titles={
    'English':'“IT IS HEALTH THAT IS REAL WEALTH AND NOT PIECES OF GOLD AND SILVER.”',
    'Hindi':'"स्वास्थ्य ही असली धन है न कि सोने और चांदी के टुकड़े।"',
    'Spanish':'"ES SALUD LO QUE ES RIQUEZA REAL Y NO PEDAZOS DE ORO Y PLATA".',
    'German':'„ES IST GESUNDHEIT, DIE WIRKLICHER WOHLSTAND IST UND KEINE GOLD- UND SILBERSTÜCKE.“',
    'French':'''"C'EST LA SANTÉ QUI EST LA VRAIE RICHESSE ET NON DES PIÈCES D'OR ET D'ARGENT."''',
    'Japanese':'「それは本当の健康であり、金や銀のかけらではない健康です。」',
    'Russian':'«НАСТОЯЩЕЕ БОГАТСТВО - ЭТО ЗДОРОВЬЕ, А НЕ ЧАСТИ ЗОЛОТА И СЕРЕБРА».',
    'Chinese':'“健康才是真正的财富，而不是黄金和白银。”',
    'Portuguese':'“É SAÚDE QUE É RIQUEZA DE VERDADE E NÃO PEDAÇOS DE OURO E PRATA.”'
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.3,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/diet.jpeg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                      ),
                    ),
                    child: Text(
                      titles[lang],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: ()=>Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                color: const Color(0xfff0f0f0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addictionName.length,
                  separatorBuilder: (context,index)=>SizedBox(height: 10,),
                  itemBuilder: (context,mainIndex){
                    return MyExpansionTile(
                      tilePadding: EdgeInsets.all(0),
                      title: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height*0.17,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage('assets/dietList/'+getFileName(addictionName[mainIndex])+'.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  addictions[lang][mainIndex],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  addictionDescription[lang][mainIndex],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),padding: EdgeInsets.only(right:5),),
                        ],
                      ),
                      children: List.generate(dietHeading[lang].length, (index) => Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          GestureDetector(
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SpecificDiet(
                              category: addictions['English'][mainIndex],
                              subcategory: dietHeading['English'][index],
                              convertedSubcategory: dietHeading[lang][index],
                              convertedDescription: dietDescription[lang][index],
                            ))),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.14,
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2.5),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color(0xc277d5f8),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    dietHeading[lang][index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19.5,
                                    ),
                                  ),
                                  Text(
                                    dietDescription[lang][index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.arrow_forward_ios_rounded,size: 20,),
                          ),
                        ],
                      )),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
