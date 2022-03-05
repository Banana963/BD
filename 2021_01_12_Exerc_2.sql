/*EXERC. 2.1*/

select distinct e.nome
from artista a
	 inner join album b on a.artista_id=b.artista
	 inner join faixas c on b.album_id=c.album
	 inner join fx_comp d on c.faixa_id=d.faixa_id
	 inner join compositor e on d.compositor=e.compositor_id
 where a.nome='ABBA';



/*EXERC. 2.2*/

select b.titulo,sum(c.duracao) as dur
from artista a inner join album b on a.artista_id=b.artista inner join faixas c on b.album_id=c.album
where a.nome='ABBA'
group by b.album_id
having dur=(SELECT sum(c.duracao) as dur
			from artista a inner join album b on a.artista_id=b.artista inner join faixas c on b.album_id=c.album
			where a.nome='ABBA'
			group by b.album_id
			order by dur desc
			limit 1);
			

/*EXERC. 2.3*/

select b.titulo,c.titulo,c.ano
from artista a
	 inner join album b on a.artista_id=b.artista
	 inner join faixas c on b.album_id=c.album
where a.nome='ABBA';


/*EXERC. 2.4*/
select b.name,count(if(a.ano<=1990,1,null)),count(if(a.ano>1990,1,null))
from faixas a inner join genero b on a.genero=b.id
group by b.id
order by b.name

/*EXERC. 2.5*/

Álbuns sem artista atribuído.

select a.album_id
from album a left join artista b on a.artista=b.artista_id
where b.artista_id is null;


Nº de artistas existentes nos álbuns sem artista atribuído,
select album,artista,count(distinct artista) as num_artistas
from faixas
where album in(select a.album_id
			   from album a left join artista b on a.artista=b.artista_id
			   where b.artista_id is null)
group by album

Afinando...
select album,if(num_artistas=1,artista,(select artista_id from artista where nome='Artistas vários')) as numero_artista
from (select album,artista,count(distinct artista) as num_artistas
	  from faixas
      where album in(select a.album_id
					 from album a left join artista b on a.artista=b.artista_id
					 where b.artista_id is null)
      group by album) a




Comandos Finais
Insert into artista values (9999,'Artistas vários');

update album inner join (select album,if(num_artistas=1,artista,(select artista_id from artista where nome='Artistas vários')) as numero_artista
						from (select album,artista,count(distinct artista) as num_artistas
							  from faixas
							  where album in(select a.album_id
											 from album a left join artista b on a.artista=b.artista_id
											 where b.artista_id is null)
							  group by album) a) tbl on album.album_id=tbl.album
set artista=tbl.numero_artista


