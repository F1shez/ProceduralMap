using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enviroment : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        this.gameObject.GetComponent<Renderer>().material.SetTexture("_MainTex", GeneratePerlinNoise());
        Vector3[] xyz = GetPeaksMap((Texture2D)this.gameObject.GetComponent<Renderer>().material.GetTexture("_MainTex"));

        GameObject go = new GameObject();
        go.name = "testmesh";

        go.AddComponent<MeshFilter>();
        go.AddComponent<MeshRenderer>();

        Mesh mesh = go.GetComponent<MeshFilter>().mesh;

        mesh.Clear();

        GenerateMesh(mesh, xyz);
    }

    // Update is called once per frame
    // void GenerateLandskape(GameObject landskape)
    // {
    //     // Mesh landskapeMesh = ;
    //     Texture aTexture;
    //     RenderTexture rTex;

    //     // Graphics.Blit();
    //     // GenerateMesh(landskape.GetComponent<MeshFilter>().mesh, GetPeaksMap((Texture2D)landskape.GetComponent<Renderer>().material.mainTexture));
    // }
    Texture2D GeneratePerlinNoise()
    {
        Shader perlinNoiseShader = Shader.Find("Custom/GetNoise");
        Material mat = new Material(perlinNoiseShader);
        Texture sampleTexture = new Texture2D(256, 256);
        // mat.SetTexture("_sampleTexture", sampleTexture);

        RenderTexture rtNoiseTexture = RenderTexture.GetTemporary(
                            sampleTexture.width,
                            sampleTexture.height,
                            0,
                            RenderTextureFormat.Default,
                            RenderTextureReadWrite.Linear);

        Graphics.Blit(sampleTexture, rtNoiseTexture, mat);

        RenderTexture.active = rtNoiseTexture;
        Texture2D noiseTexture = new Texture2D(sampleTexture.width, sampleTexture.height);
        noiseTexture.ReadPixels(new Rect(0, 0, rtNoiseTexture.width, rtNoiseTexture.height), 0, 0);
        noiseTexture.Apply();
        RenderTexture.active = null;

        RenderTexture.ReleaseTemporary(rtNoiseTexture);

        return noiseTexture;
    }
    public Vector3[] GetPeaksMap(Texture2D noiseTex)
    {
        List<Vector3> perlinData = new List<Vector3>();

        for (int i = 0; i < noiseTex.width; i++)
        {
            for (int j = 0; j < noiseTex.height; j++)
            {
                float k = noiseTex.GetPixel(i, j).grayscale;
                Vector3 transform = new Vector3(i, j, k);
                perlinData.Add(transform);
            }
        }
        return perlinData.ToArray();
    }
    public Mesh GenerateMesh(Mesh mesh, Vector3[] peaksMap)
    {
        int xSize;
        int ySize = xSize = Convert.ToInt16(Math.Sqrt(peaksMap.Length)) - 1;
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
}
