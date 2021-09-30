import 'package:addictx/models/dataModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Resource extends StatelessWidget {
  final DataModel dataModel;

  Resource({this.dataModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_horiz),
          ),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(dataModel.url),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  dataModel.heading,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    dataModel.content[0],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
