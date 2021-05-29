using System.Globalization;
using System.Net.Mime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class LoaderData : MonoBehaviour
{
    // Start is called before the first frame update
    public static Vector3[] LoaderNoiseImage(string path)
    {
        List<Vector3> perlinData = new List<Vector3>();
        Texture2D tex = null;
        byte[] fileData;

        if (File.Exists(path))
        {
            fileData = File.ReadAllBytes(path);
            tex = new Texture2D(2, 2);
            tex.LoadImage(fileData);
        }
        for (int i = 0; i < tex.width; i++)
        {
            for (int j = 0; j < tex.height; j++)
            {
                float k = tex.GetPixel(i, j).grayscale;
                Vector3 transform = new Vector3(i, j, k);
                perlinData.Add(transform);
            }
        }
        return perlinData.ToArray();
    }
}