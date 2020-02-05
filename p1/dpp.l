/*
 * file:  dpp.l
 * ------------
 * Lex inupt file to generate the scanner for the preprocessor.
 * If you decide to use lex for the preprocesor, put your rules
 * here, otherwise the file can remain empty.
 */
%{
#include <unordered_map>
#include <string>
#include <iostream>
#include "errors.h"

std::unordered_map<std::string, std::string> macros;
int numLine = 1;
bool leftComment = false;

%}

%%

.*"/*".*"*/"            {
                            std::string s = strdup(yytext);
                            int pos = s.find("/*");
                            std::string st = s.substr(0, pos);
                            std::cout<<st.c_str();
                        }

.*"/*".*                {
                            leftComment = true;
                            std::string s = strdup(yytext);
                            int pos = s.find("/*");
                            std::string st = s.substr(0, pos);
                            std::cout<<st.c_str();
                        }

.*"*/"                  {
                            if(leftComment)
                                leftComment = false;
                            else   
                                std::cout<<yytext;
                        }

.*"//".*                {
                            if(!leftComment){
                                std::string s = strdup(yytext);
                                int pos = s.find("//");
                                std::string st = s.substr(0, pos);
                                std::cout<<st.c_str();
                            }
                        }

"#define "[A-Z]+" ".*   {
                            std::string text, textTodo, macro, replace;
                            text = strdup(yytext);
                            textTodo = text.substr(8);
                            int pos = textTodo.find(" ");
                            macro = textTodo.substr(0, pos);
                            replace = textTodo.substr(pos+1);
                            macros[macro] = replace;
                        }

"#"[A-Z]+               {
                            std::string text, macro;
                            text = strdup(yytext);
                            macro = text.substr(1);
                            if(macros.find(macro) == macros.end())
                                ReportError::InvalidDirective(numLine);                                
                            else
                                std::cout<<macros[macro].c_str();
                        }

"#define".*             ReportError::InvalidDirective(numLine);

"\n"                    {
                            numLine++;
                            if(leftComment) std::cout<<'\n';
                            else ECHO;
                        }

<<EOF>>                 {
                            if(leftComment)
                                ReportError::UntermComment();
                            return 0;
                        }

.                       if(!leftComment) ECHO;
                            
%%
