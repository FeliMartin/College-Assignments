#include <iostream>
#include <string>
#include <vector>
#include<bits/stdc++.h>
using namespace std;
#define INF 0x3f3f3f3f

//Descripcion del problema
/*
Un rascacielos no tiene mas de 100 pisos (del 0 al 99). Tiene entre 1 y 5 ascensores.
Los ascensores pueden viajar a distintas velocidades y no todos van a los mismos pisos.
Estamos en el piso 0 y queremos ir hasta el piso k de la forma mas rapida. Ir al primer
ascensor no cuesta nada, pero despues cambiar de ascensor cuesta 60 segundos. No podemos
usar la escalera.
Input: 
n (numero de ascensores), k (piso objetivo)
T1 ... Tn (velocidad de cada ascensor)
n lineas con los pisos en los que para cada ascensor
*/

struct arista {
    int v;
    int peso;
};

typedef vector<vector<arista>> grafo;
typedef int nodo;
typedef int dist;

vector<int> str_to_vec(string str){
    int it = 0;
    int i = 0;
    vector<int> res;
    res.push_back(0);

    while (str[it] != 0){
        if(str[it] == ' '){
            it++;
            i++;
            res.push_back(0);
        }
        res[i] = (res[i]*10) + (str[it]-48);
        it++;
    }
    return res;
}

vector<dist> dijkstra(grafo& g, int source){
    //Implementamos Dijkstra con un set:
    
    //set<pair<dist, nodo>> , de esta manera ordena por distancia
    //El set arranca vacio
    set<pair<dist, nodo>> q;
        
    vector<nodo> distancias(g.size(), INF);
    distancias[source] = 0;

    //Insertamos <0, src> en el set
    q.insert(make_pair(0, source));

    //Mientras que el set no este vacio
    while(!q.empty()){
        //Sacamos el mas chico (set.begin)
        pair<dist, nodo> primero = *(q.begin());
        q.erase(primero);

        nodo vecino;
        dist peso;
        
        //Iteramos sobre la adyacencia del vertice
        for(int i=0; i<g[primero.second].size(); i++){
            vecino = g[primero.second][i].v;
            peso = g[primero.second][i].peso;

            if(distancias[vecino] > distancias[primero.second] + peso){
                //Si la distancia del vecino era distinta a INF => Esta en q 
                if(distancias[vecino] != INF){
                    q.erase(q.find(make_pair(distancias[vecino], vecino)));
                }
                //Actualizamos la distancia del vecino y lo ponemos en q
                distancias[vecino] = distancias[primero.second] + peso;
                q.insert(make_pair(distancias[vecino], vecino));
            }
        }
    }

    return distancias;
    
}

void ej10(int cant_ascensores){
    //piso objetivo
    int k;
    cin >> k; 

    //velocidades de ascensores
    vector<int> vel(cant_ascensores);
    for(int i=0; i<cant_ascensores; i++){
        cin >> vel[i];
        
    }

    //inicializamos el grafo
    vector<arista> vacio = {};
    //|V| = cant_ascensores * 100 + 100
    int v = (cant_ascensores*100)+100;
    grafo g(v, vacio);
    
    //ponemos las aristas
    arista uv;
    
    cin.ignore();

    for(int j=0; j<cant_ascensores; j++){
        string pisos;
        //cargamos los pisos del ascensor j en un string
        getline(cin, pisos);
        //pasamos los pisos a un vector de enteros
        vector<int> pisos_j = str_to_vec(pisos);

        //agregamos los pisos del ascensor al grafo
        //el ascensor j empieza en el vertice 100*j

        //Toda parada de ascensor conecta con la siguiente
        int l;
        for(l=1; l<pisos_j.size(); l++){
            uv.v = (100*(j+1)) + pisos_j[l];
            uv.peso = vel[j] * (pisos_j[l] - pisos_j[l-1]);
            g[(100*(j+1)) + pisos_j[l-1]].push_back(uv);
        }

        //Toda parada de ascensor conecta con su anterior
        for(l=0; l<pisos_j.size()-1; l++){
            uv.v = (100*(j+1)) + pisos_j[l];
            uv.peso = vel[j] * (pisos_j[l+1] - pisos_j[l]);
            g[(100*(j+1)) + pisos_j[l+1]].push_back(uv);
        }

        //Toda parada de ascensor conecta con el piso del edificio
        //y todo piso se conecta con los ascensores que paren en ese piso
        for(l=0; l<pisos_j.size(); l++){
            uv.v = pisos_j[l];
            uv.peso = 0;
            g[(100*(j+1)) + pisos_j[l]].push_back(uv);
            
            //Si el piso es 0 conecta con peso 0, sino con 60
            if(pisos_j[l] == 0){
                uv.v = (100*(j+1));
                g[0].push_back(uv);
            } else{
                uv.v = (100*(j+1))+pisos_j[l];
                uv.peso = 60;
                g[pisos_j[l]].push_back(uv);
            }
        }   
        
    }

    //Corremos Dijkstra desde el vertice 0
    vector<int> dist_min = dijkstra(g, 0);

    //Devolvemos la distancia minima a k
    if(dist_min[k] != INF){
        cout << dist_min[k] << endl;
    } else{
        cout << "IMPOSSIBLE" << endl;
    }

}

int main(){
    int n;
    while(cin >> n){
        ej10(n);
    }
    return 0;
}