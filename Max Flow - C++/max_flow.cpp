#include <iostream>
#include <vector>
#include <string>
using namespace std;
typedef int capacity_t;
typedef int vertex_t;
typedef int flow_t;
typedef int edge_t; 
typedef vector<vector<edge_t>> graph_t;
typedef vector<vector<capacity_t>> capacity_matrix_t;
typedef vector<vector<flow_t>> flow_matrix_t;
#define INF 0x3f3f3f3f

int bfs(graph_t& graph, capacity_matrix_t& capacity_matrix, flow_matrix_t& flow_matrix){
    int i;
    int j;
    int k;

    graph_t residual_graph(graph.size());
    for(int i=0; i<graph.size(); i++){
        for(j=0; j<graph[i].size(); j++){
            vertex_t v = graph[i][j];
            capacity_t c = capacity_matrix[i][v];
            flow_t f = flow_matrix[i][v];
            
            if(0 < f && f < c){
                residual_graph[i].push_back(v);
                residual_graph[v].push_back(i);
            }
            else if(f == c){
                residual_graph[v].push_back(i);
            }
            else if(f == 0){
                residual_graph[i].push_back(v);
            }
        }
    }

    //Looks for the augmenting path
    vector<vertex_t> predcessor(graph.size(), -1);
    vector<bool> visited(graph.size(), false);
    vector<vertex_t> frontier;
    frontier.push_back(0);
    visited[0] = true;
    while(!frontier.empty()){
        vector<vertex_t> next;
        for(i=0; i<frontier.size(); i++){
            for(j=0; j<residual_graph[frontier[i]].size(); j++){
                vertex_t v = residual_graph[frontier[i]][j];
                if(!visited[v]){
                    visited[v] = true;
                    next.push_back(v);
                    predcessor[v] = frontier[i];
                }
            }
        }
        frontier = next;
    }

    if(predcessor[residual_graph.size()-1] == -1){
        return 0;
    } 
    else{
        int res = INF;
        int delta = 0;
        vertex_t current_vertex = residual_graph.size()-1;
        while(predcessor[current_vertex] != -1){
            //Δ(ij)
            if(capacity_matrix[predcessor[current_vertex]][current_vertex] != -1){
                delta = capacity_matrix[predcessor[current_vertex]][current_vertex] - flow_matrix[predcessor[current_vertex]][current_vertex];
            } else{
                delta = flow_matrix[current_vertex][predcessor[current_vertex]];
            }
            delta < res ? res = delta : res = res;   
            current_vertex = predcessor[current_vertex]; 
        }

        //Updates graphs flow by the delta value stored in res
        current_vertex = residual_graph.size()-1;
        while(predcessor[current_vertex] != -1){
            if(capacity_matrix[predcessor[current_vertex]][current_vertex] != -1){
                flow_matrix[predcessor[current_vertex]][current_vertex] += res;
            } else{
                flow_matrix[current_vertex][predcessor[current_vertex]] -= res;
            }
            current_vertex = predcessor[current_vertex];
        }

        return res;
    }

}

int edmond_karps(graph_t& graph, capacity_matrix_t& capacity_matrix, flow_matrix_t& flow_matrix){
    int res = 0;
    int new_flow;
    while(new_flow = bfs(graph, capacity_matrix, flow_matrix)){ 
        res+=new_flow;
    }
    return res;
}

void ej13(){
    int number_of_tshirts;
    int number_of_volunteers;
    cin >> number_of_tshirts;
    cin >> number_of_volunteers;
    
    
    //|V| = 6 + number_of_volunteers + 2 (6 for the sizes and 2 for the source and sink)
    //0 = s, 
    //[1, ..., 6] = XS, S, ...
    //[6+1, 6+M] = Volunteer 1, Volunteer 2, ...
    //7+M = t
    
    graph_t graph(number_of_volunteers+8);
    capacity_matrix_t capacity_matrix(number_of_volunteers+8, vector<capacity_t>(number_of_volunteers+8, -1));
    flow_matrix_t flow_matrix(number_of_volunteers+8, vector<flow_t>(number_of_volunteers+8, 0));

    int i;
    int j;

    //Adds edges from source to tshirt sizes
    for(int tshirt_size_i=1; tshirt_size_i<=6; tshirt_size_i++){
        graph[0].push_back(tshirt_size_i);
        capacity_matrix[0][tshirt_size_i] = number_of_tshirts/6;
    }

    //Adds edges from tshirt sizes to volunteers
    string fit;
    for(int ith_volunteer=1; ith_volunteer<=number_of_volunteers; ith_volunteer++){
        for(int j=0; j<2; j++){
            cin >> fit;
            if(fit == "XS"){
                graph[1].push_back(6+ith_volunteer);
                capacity_matrix[1][6+ith_volunteer] = 1;
            } 
            else if(fit == "S"){
                graph[2].push_back(6+ith_volunteer);
                capacity_matrix[2][6+ith_volunteer] = 1;
            }
            else if(fit == "M"){
                graph[3].push_back(6+ith_volunteer);
                capacity_matrix[3][6+ith_volunteer] = 1;
            }
            else if(fit == "L"){
                graph[4].push_back(6+ith_volunteer);
                capacity_matrix[4][6+ith_volunteer] = 1;
            }
            else if(fit == "XL"){
                graph[5].push_back(6+ith_volunteer);
                capacity_matrix[5][6+ith_volunteer] = 1;
            }
            else if(fit == "XXL"){
                graph[6].push_back(6+ith_volunteer);
                capacity_matrix[6][6+ith_volunteer] = 1;
            }
        }
    }

    //Adds edges from volunteers to the sink
    for(int ith_volunteer=1; ith_volunteer<=number_of_volunteers; ith_volunteer++){
        graph[6+ith_volunteer].push_back(7+number_of_volunteers);
        capacity_matrix[6+ith_volunteer][7+number_of_volunteers] = 1;
    }

    int res = edmond_karps(graph, capacity_matrix, flow_matrix);
    res == number_of_volunteers ? cout << "YES" << endl : cout << "NO" << endl;
    
}

int main(){
    int test_case;
    cin >> test_case;
    while(test_case>0){
        ej13();
        test_case--;
    }
    return 0;
}