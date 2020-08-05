import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';

class CompaniesPromo extends StatelessWidget {
  final List<Company> companies;
  CompaniesPromo(this.companies);
  final companyScreenBloc = BlocProvider.getBloc<CompanyScreenBloc>();

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20), left: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              'Lojas em promoções',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(36)
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: companies.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return cardPromo(companies[index], context, companyScreenBloc);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cardPromo(Company company, BuildContext context, CompanyScreenBloc companyScreenBloc){
  
  Image image;
  if(company.contentType =="image/jpeg" || company.contentType =="image/png"){
    image = Image.memory(base64Decode(company.content));
  }


  return GestureDetector(
      onTap: (){
        if(company.aberto == "true" && company.offline == "false"){
          companyScreenBloc.addCompany(company);
          Navigator.pushNamed(context, "/company_screen");
        }
        
      } ,
      child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(10), 
              top: ScreenUtil().setHeight(20),
            right: ScreenUtil().setWidth(25)

          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              height: ScreenUtil().setHeight(130),
              width: ScreenUtil().setWidth(180),
              child: Stack(
                children: <Widget>[
                  image == null? Container() : Image(image: image.image,
                    width: ScreenUtil().setWidth(180),
                    height: ScreenUtil().setHeight(130),
                    fit: BoxFit.fitWidth,
                  ),
                  company.lojaPromocao && company.descontoGofood == 'null' ? Container() :
                  Positioned(
                    top: ScreenUtil().setHeight(5),
                    left: ScreenUtil().setWidth(5),
                    child: CircleAvatar(
                      radius: ScreenUtil().setHeight(24),
                      backgroundColor: Colors.white,
                      child: Center(
                        child: 
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: ScreenUtil().setHeight(22),
                          child: Center(
                            child: Text("-${company.descontoGofood}%",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(15)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  company.aberto == "true" && company.offline == "false" ? Container(
                    
                  ) : Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Text("Fechado",
                        style: TextStyle(
                          color: Colors.white
                        ), 
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
          width: ScreenUtil().setWidth(180),
          child: Center(
            child: Text(
              company.empresaNome.trim(),
              maxLines: 4,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  fontSize: ScreenUtil().setSp(26)
              ),
            ),
          ),
        ),
      ],
    ),
  );
}