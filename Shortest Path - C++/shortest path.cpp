#include <iostream>
#include <string>
#include <vector>
#include<bits/stdc++.h>
using namespace std;
#define INF 0x3f3f3f3f

struct edge {
    int v;
    int weight;
};

typedef vector<vector<edge>> graph_t;
typedef int vertex;
typedef int dist;

vector<int> string_to_vector(string str){
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

vector<dist> dijkstra(graph_t& graph, int source){
    set<pair<dist, vertex>> q;
        
    vector<vertex> distances(graph.size(), INF);
    distances[source] = 0;

    q.insert(make_pair(0, source));

    while(!q.empty()){
        pair<dist, vertex> primero = *(q.begin());
        q.erase(primero);

        vertex adyacent;
        dist w;
        
        for(int i=0; i<graph[primero.second].size(); i++){
            adyacent = graph[primero.second][i].v;
            w = graph[primero.second][i].weight;

            if(distances[adyacent] > distances[primero.second] + w){
                if(distances[adyacent] != INF){
                    q.erase(q.find(make_pair(distances[adyacent], adyacent)));
                }
                //Updates distance of adyacent vertex to source in the queue
                distances[adyacent] = distances[primero.second] + w;
                q.insert(make_pair(distances[adyacent], adyacent));
            }
        }
    }

    return distances;
    
}

void ej10(int number_of_lifts){
    int objective;
    cin >> objective; 

    vector<int> speed(number_of_lifts);
    for(int i=0; i<number_of_lifts; i++){
        cin >> speed[i];
        
    }

    //vector<edge> vacio = {};
    //|V| = number_of_lifts * 100 + 100
    int v = (number_of_lifts*100)+100;
    graph_t graph(v);
    
    //Inserts edges in graph
    edge uv;
    
    cin.ignore();

    for(int j=0; j<number_of_lifts; j++){
        string floors;
        getline(cin, floors);
        vector<int> jth_lift_stops = string_to_vector(floors);

        //The jth lift begins on vertex j*100

        //Each lift stop connects with its the next one
        int l;
        for(l=1; l<jth_lift_stops.size(); l++){
            uv.v = (100*(j+1)) + jth_lift_stops[l];
            uv.weight = speed[j] * (jth_lift_stops[l] - jth_lift_stops[l-1]);
            graph[(100*(j+1)) + jth_lift_stops[l-1]].push_back(uv);
        }

        //Each lift stop connects with its previous one
        for(l=0; l<jth_lift_stops.size()-1; l++){
            uv.v = (100*(j+1)) + jth_lift_stops[l];
            uv.weight = speed[j] * (jth_lift_stops[l+1] - jth_lift_stops[l]);
            graph[(100*(j+1)) + jth_lift_stops[l+1]].push_back(uv);
        }

        //Each lift stop connects with the building floor it is on
        //and each building floor connects with all lifts that stop on that floor
        for(l=0; l<jth_lift_stops.size(); l++){
            uv.v = jth_lift_stops[l];
            uv.weight = 0;
            graph[(100*(j+1)) + jth_lift_stops[l]].push_back(uv);
            
            if(jth_lift_stops[l] == 0){
                uv.v = (100*(j+1));
                graph[0].push_back(uv);
            } else{
                uv.v = (100*(j+1))+jth_lift_stops[l];
                uv.weight = 60;
                graph[jth_lift_stops[l]].push_back(uv);
            }
        }   
        
    }

    vector<int> dist_min = dijkstra(graph, 0);

    if(dist_min[objective] != INF){
        cout << dist_min[objective] << endl;
    } else{
        cout << "IMPOSSIBLE" << endl;
    }

}

int main(){
    int number_of_lifts;
    while(cin >> number_of_lifts){
        ej10(number_of_lifts);
    }
    return 0;
}