
create table seccao(numsec int primary key,
                    nome varchar(30),
                    cidade varchar(25),
                    orcamento_2020 int,
                    orcamento_2019 int);

create table funcionario(numfunc int primary key,
                         nome varchar(30),
                         apelido varchar(30),
                         seccao int,
						 posto varchar(30),
						 chefe int,
						 salario int,
                         despesas int,
                         carro set('sim','nã0'),
                         foreign key (seccao) references seccao(numsec));
						 
insert into seccao values
(10,'Fabrico','Porto',2600000,230000),
(20,'Comercial','Porto',180000,195000),
(30,'Marketing','Braga',60000,55000),
(40,'Planeamento','Guimarães',70000,58000),
(50,'Administração','Porto',225000,230000),
(60,'Informática','Braga',125000,90000),
(70,'Recursos Humanos','Lisboa',80000,58000);

						 
insert into funcionario values(1,'Ana','Silva',10,'Programador',3,3000,10,'Não'),
(2,'Nuno','Marques',70,'Engenheiro',1,1500,40,'Sim'),
(3,'Álvaro','Sousa',50,'Administrador',null,2500,10,'Sim'),
(4,'António','Silva',10,'Engenheiro',1,1450,20,'Não'),
(5,'Susana','Santiago',20,'Administrador',3,2750,30,'Não'),
(6,'Ana','ousa',60,'Vendedor',4,1000,50,'Sim'),
(7,'Carlos','Sousa',50,'Contabilista',3,1500,10,'Não');



/*EXERC. 3.1*/

select nome, 14*salario+12*salario*(despesas/100)-14*salario*0,25 as total_anual
from funcionario



/*EXERC. 3.2*/

select seccao.nome
from seccao left join funcionario on seccao.numsec=funcionario.seccao
where funcionario.seccao is null


/*EXERC. 3.3*/

select nome,posto,salario
from funcionario a
where salario> all (select salario from funcionario b where b.posto=a.posto and b.numfunc<>a.numfunc )


/*EXERC. 3.4*/
Este exercício necessita de uma explicação, uma vez que o texto contém uma imprecisão.

Preparação - cálculo dos funcionários que obedecem às condições

select numfunc
from funcionario a
where salario>=(select avg(salario) from funcionario b where b.seccao=a.seccao)
      and numfunc in (select distinct chefe from funcionario)           
	  
	  
Comando final	  
	  
update funcionario
set carro ='sim'
where numfunc in (select * from(select numfunc
from funcionario a
where salario>=(select avg(salario) from funcionario b where b.seccao=a.seccao)
      and numfunc in (select distinct chefe from funcionario) ) a)

/*EXERC. 3.5*/

Total de remunerações por secção

select numsec,cidade,seccao.nome,sum(14*salario+12*salario*(despesas/100)) as soma_rem
from seccao inner join funcionario on numsec=seccao
group by numsec

Secção com maior valor

select numsec
from seccao inner join funcionario on numsec=seccao
group by numsec
having sum(14*salario+12*salario*(despesas/100))=(select max(soma_rem) from (select numsec,cidade,seccao.nome,sum(14*salario+12*salario*(despesas/100)) as soma_rem
												  from seccao inner join funcionario on numsec=seccao
                                                  group by numsec) a)

Cidade que tem a secção com menor valor

select cidade
from seccao inner join funcionario on numsec=seccao
group by numsec
having sum(14*salario+12*salario*(despesas/100))=(select min(soma_rem) from (select numsec,cidade,seccao.nome,sum(14*salario+12*salario*(despesas/100)) as soma_rem
												  from seccao inner join funcionario on numsec=seccao
                                                  group by numsec) a)
												  
Comando Final												  
update seccao
set cidade=(select * from (select cidade
            from seccao inner join funcionario on numsec=seccao
            group by numsec
            having sum(14*salario+12*salario*(despesas/100))=(select min(soma_rem) from (select numsec,cidade,seccao.nome,sum(14*salario+12*salario*(despesas/100)) as soma_rem
                                                  from seccao inner join funcionario on numsec=seccao
                                                  group by numsec) a)) tbl)
where numsec=(select * from (select numsec
              from seccao inner join funcionario on numsec=seccao
              group by numsec
               having sum(14*salario+12*salario*(despesas/100))=(select max(soma_rem) from (select numsec,cidade,seccao.nome,sum(14*salario+12*salario*(despesas/100)) as soma_rem
                                                  from seccao inner join funcionario on numsec=seccao
                                                  group by numsec) a)) tbl)