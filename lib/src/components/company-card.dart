import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-settings.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  CompanyCard(this.company);
  @override
  Widget build(BuildContext context) {
    final companyScreenBloc = BlocProvider.getBloc<CompanyScreenBloc>();

    Image image;
    if(company.contentType =="image/jpeg" || company.contentType =="image/png"){
      image = Image.memory(base64Decode(company.content), fit: BoxFit.fill,);
    }
    return GestureDetector(
      onTap: (){
        if(company.aberto == "true" && company.offline == "false")
        {
          companyScreenBloc.addCompany(company);
          Navigator.pushNamed(context, "/company_screen");
        }
        
      },
      child: Container(
        height: ScreenUtil().setHeight(170),
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(20)
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(200),
                  child: image == null ? Center(
                      child: CircleAvatar(
                        radius: ScreenUtil().setHeight(50),
                        backgroundColor: Colors.grey.shade200,
                      )
                  ) : Center(
                    child: CircleAvatar(
                      radius: ScreenUtil().setHeight(50),
                      backgroundImage: image.image,
                      backgroundColor: Colors.grey.shade200,
                    )
                  )
                ),
                (company.aberto == "true" && company.offline == "false")  ? Container(
                  
                ) : Container(
                  color: Colors.black.withOpacity(0.4) ,
                  width: ScreenUtil().setWidth(200),
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
            Container(
              width: 1,
              height: ScreenUtil().setHeight(140),
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(company.empresaNome,
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.w700
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Row(
                      children: <Widget>[
                        double.parse(company.classificao) == 0 ?
                            Text("Novo",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                                fontSize: ScreenUtil().setSp(23)
                              ),
                            )
                            : Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star,
                                    color: Colors.amber,
                                    size: ScreenUtil().setHeight(25),
                                  ),
                                  Text(" ${company.classificao.replaceAll(".", ",")}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.amber,
                                        fontSize: ScreenUtil().setSp(23)
                                    ),
                                  )
                                ],
                              ),
                            ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Icon(
                          Icons.brightness_1,
                          size: ScreenUtil().setHeight(10),
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Text("${company.categoria.descricao}",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(23)
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Icon(
                          Icons.brightness_1,
                          size: ScreenUtil().setHeight(10),
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Text("${company.distanciaCliente} km",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(23)
                          ),
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                    Row(
                      children: <Widget>[
                        Text("${company.tempoMinimoEntrega}  - "
                            "${company.tempoMaximoEntrega} min",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(23)
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(13),
                        ),
                        Icon(
                          Icons.brightness_1,
                          size: ScreenUtil().setHeight(10),
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(13),
                        ),
                        Text(formatPrice(double.parse(company.valorFrete)),
                            style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(23)
                        ),
                      )
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              ),
            )
          ],
        ),
      ),
    );
                 
  }
}