#include <iostream>
#include <vector>
#include <string>
using namespace std;
typedef int cap;
typedef int vert;
typedef int flujo;
typedef int arista; 
typedef vector<vector<arista>> grafo;
typedef vector<vector<cap>> mat_cap;
typedef vector<vector<flujo>> mat_flujo;
#define INF 0x3f3f3f3f

int bfs(grafo& g, mat_cap& m_c, mat_flujo& m_f){
    int i;
    int j;
    int k;

    //Armamos el grafo residual Gr
    grafo gr(g.size());
    for(i=0; i<g.size(); i++){
        for(j=0; j<g[i].size(); j++){
            vert v = g[i][j];
            cap c = m_c[i][v];
            flujo f = m_f[i][v];
            //Si 0 < f(uv) < c(uv) => uv y vu pertenecen a Gr
            if(0 < f && f < c){
                gr[i].push_back(v);
                gr[v].push_back(i);
            }
            //Si f(uv) = c(uv) => vu pertenece a Gr
            else if(f == c){
                gr[v].push_back(i);
            }
            //Si f(uv) = 0 => uv pertenece a Gr 
            else if(f == 0){
                gr[i].push_back(v);
            }
        }
    }

    //Buscamos el camino de aumento
    vector<vert> padre(g.size(), -1);
    vector<bool> visitado(g.size(), false);
    vector<vert> frontier;
    frontier.push_back(0);
    visitado[0] = true;
    while(!frontier.empty()){
        vector<vert> next;
        for(i=0; i<frontier.size(); i++){
            for(j=0; j<g[frontier[i]].size(); j++){
                vert v = g[frontier[i]][j];
                if(!visitado[v] && (m_c[frontier[i]][v] != m_f[frontier[i]][v])){
                    visitado[v] = true;
                    next.push_back(v);
                    padre[v] = frontier[i];
                }
            }
        }
        frontier = next;
    }

    //Si no hay camino de S a T devolvemos 0.
    if(padre[gr.size()-1] == -1){
        return 0;
    } 
    //Sino devolvemos Δ(P)
    else{
        int res = INF;
        int delta = 0;
        vert actual = gr.size()-1;
        while(padre[actual] != -1){
            //Δ(ij)
            if(m_c[padre[actual]][actual] != -1){
                delta = m_c[padre[actual]][actual] - m_f[padre[actual]][actual];
            } else{
                delta = m_f[actual][padre[actual]];
            }
            delta < res ? res = delta : res = res;   
            actual = padre[actual]; 
        }

        //Actualizamos el flujo de G
        actual = gr.size()-1;
        while(padre[actual] != -1){
            if(m_c[padre[actual]][actual] != -1){
                m_f[padre[actual]][actual] += res;
            } else{
                m_f[actual][padre[actual]] -= res;
            }
            actual = padre[actual];
        }

        return res;
    }

}

int edmond_karps(grafo& g, mat_cap& m_c, mat_flujo& m_f){
    int res = 0;
    int new_flow;
    while(new_flow = bfs(g, m_c, m_f)){ //mientras que new_flow sea distinto de 0
        res+=new_flow;
    }
    return res;
}

void ej13(){
    int N;
    int M;
    cin >> N;
    cin >> M;
    
    //Inicializo el grafo
    //Como sabemos que no hay aristas "inversas" podemos usar este grafo tambien para el residual
    //agregando las aristas inversas
    
    //|V| = 6 + M + 2 (6 por los talles, M por las personas y 2 por s y T)
    //0 = s, 
    //[1, ..., 6] = XS, S, ...
    //[6+1, 6+M] = P1, P2, ...
    //7+M = t
    

    grafo g(M+8);
    mat_cap m_c(M+8, vector<cap>(M+8, -1));
    mat_flujo m_f(M+8, vector<flujo>(M+8, 0));

    int i;
    int j;

    //Ponemos aristas de s a tamaños de ropa
    for(i=1; i<=6; i++){
        g[0].push_back(i);
        g[i].push_back(0); //arista inversa
        m_c[0][i] = N/6;
        m_c[i][0] = N/6;
        m_f[i][0] = N/6;
    }

    //Ponemos las aristas de los tamaños de ropa a las personas
    string fit;
    for(i=1; i<=M; i++){
        for(j=0; j<2; j++){
            cin >> fit;
            if(fit == "XS"){
                g[1].push_back(6+i);
                g[6+i].push_back(1); //arista inversa
                m_c[1][6+i] = 1;
                m_c[6+i][1] = 1;
                m_f[6+i][1] = 1;
            } 
            else if(fit == "S"){
                g[2].push_back(6+i);
                g[6+i].push_back(2); //arista inversa
                m_c[2][6+i] = 1;
                m_c[6+i][2] = 1;
                m_f[6+i][2] = 1;
            }
            else if(fit == "M"){
                g[3].push_back(6+i);
                g[6+i].push_back(3); //arista inversa
                m_c[3][6+i] = 1;
                m_c[6+i][3] = 1;
                m_f[6+i][3] = 1;
            }
            else if(fit == "L"){
                g[4].push_back(6+i);
                g[6+i].push_back(4); //arista inversa
                m_c[4][6+i] = 1;
                m_c[6+i][4] = 1;
                m_f[6+i][4] = 1;
            }
            else if(fit == "XL"){
                g[5].push_back(6+i);
                g[6+i].push_back(5); //arista inversa
                m_c[5][6+i] = 1;
                m_c[6+i][5] = 1;
                m_f[6+i][5] = 1;
            }
            else if(fit == "XXL"){
                g[6].push_back(6+i);
                g[6+i].push_back(6); //arista inversa
                m_c[6][6+i] = 1;
                m_c[6+i][6] = 1;
                m_f[6+i][6] = 1;
            }
        }
    }

    //Ponemos las aristas de las personas a t
    for(i=1; i<=M; i++){
        g[6+i].push_back(7+M);
        g[7+M].push_back(6+i); //arista inversa
        m_c[6+i][7+M] = 1;
        m_c[7+M][6+i] = 1;
        m_f[7+M][6+i] = 1;
    }

    int res = edmond_karps(g, m_c, m_f);
    res == M ? cout << "YES" << endl : cout << "NO" << endl;
    
}

int main(){
    int T;
    cin >> T;
    while(T>0){
        ej13();
        T--;
    }
    return 0;
}


/*
BFS(){
    frontier = {0}
    while(!frontier.empty){
        vec next = empty;
        for(i < frontier.size()){
            for(j < g[frontier[i]].size()){
                Si la arista frontier[i]->g[frontier[i]][j] no tiene cap = flujo
                Y
                No fue visitada
                1.La agregamos a next 
                2.La marcamos visitada
                3.padre[g[frontier[i]][j]] = frontier[i];
            }
            frontier = next;
        }

    }
}
*/