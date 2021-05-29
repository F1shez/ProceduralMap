using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoaderMap : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Vector3[] peaksMap = LoaderData.LoaderNoiseImage("/Users/notahero/Desktop/procgen/noiseframe000.png");

        int sizeMap = Convert.ToInt16(Math.Sqrt(peaksMap.Length));

        Debug.Log(sizeMap);

        GameObject go = new GameObject();
        go.name = "testmesh";

        go.AddComponent<MeshFilter>();
        go.AddComponent<MeshRenderer>();

        Mesh mesh = go.GetComponent<MeshFilter>().mesh;

        mesh.Clear();

        go.GetComponent<MeshFilter>().mesh = Generate(mesh, peaksMap);

        // go.transform.localRotation = new Quaternion(90, 0, 0, 0);
        // go.transform.localRotation = new Quaternion(180, 0, 0, 0);
    }
    public Mesh Generate(Mesh mesh, Vector3[] peaksMap)
    {
        int xSize;
        int ySize = xSize = Convert.ToInt16(Math.Sqrt(peaksMap.Length))-1;
        // int ySize = xSize = 199;
        mesh.name = "Procedural Grid";

        var vertices = mesh.vertices;

        vertices = new Vector3[(xSize + 1) * (ySize + 1)];
        Vector2[] uv = new Vector2[vertices.Length];

        for (int i = 0, y = 0; y < ySize + 1; y++)
        {
            for (int x = 0; x < xSize + 1; x++, i++)
            {
                vertices[i] = new Vector3(x, peaksMap[i].z * 100, y);
                // vertices[i] = new Vector3(x, y, 5);
                uv[i] = new Vector2((float)x / xSize, (float)y / ySize);
            }
        }
        mesh.vertices = vertices;
        mesh.uv = uv;


        int[] triangles = new int[xSize * ySize * 6];
        for (int ti = 0, vi = 0, y = 0; y < ySize; y++, vi++)
        {
            for (int x = 0; x < xSize; x++, ti += 6, vi++)
            {
                triangles[ti] = vi;
                triangles[ti + 3] = triangles[ti + 2] = vi + 1;
                triangles[ti + 4] = triangles[ti + 1] = vi + xSize + 1;
                triangles[ti + 5] = vi + xSize + 2;
            }
        }
        mesh.triangles = triangles;
        mesh.RecalculateNormals();

        return mesh;
    }

    public static GameObject CreateMeshMap(Vector3[] Data)
    {
        return null;
    }

}
